import { writable, get } from "svelte/store";
import { tweened } from "svelte/motion";
import { Operation, OperationCategory } from "../../operations/types";
import { blockNumber, transactions, receipts } from "../network";
import { player, playerActivity, Activities, categoryToActivity } from "../player";
import { uiState } from "../ui";
import { EntityType } from "../entities";
import { playSound } from "../../../howler";
import { ContractReceipt } from "ethers";

// --- STORES -----------------------------------------------------------------

export type SequenceElement = {
  operation: Operation;
  success: boolean;
};

enum SequencerState {
  Inactive,
  Executing,
  Waiting,
  Error,
}

// --- CONSTANTS -----------------------------------------------------------------

export const emptySequenceElement: SequenceElement = {
  operation: {
    name: "+",
    category: OperationCategory.Empty,
    metadata: {
      description: "",
      errorMessage: "",
    },
    costs: [],
    requirement: () => false,
    execute: () => false,
  },
  success: true,
};

export const SEQUENCER_LENGTH = 7;

// --- STORES -----------------------------------------------------------------

export const sequence = writable([] as SequenceElement[]);
export const sequencerActive = writable(false);
export const activeOperationIndex = writable(0);
export const progress = tweened(0);
export const operationDuration = writable(0);

let oldCoolDownBlock = 0;
let turnCounter = 0;
let blockDelay = 0;

export function submitSequence(newSequence: SequenceElement[]) {
  sequence.set(newSequence);
}

export function startSequencer() {
  turnCounter = 0;
  sequencerActive.set(true);
}

export function stopSequencer() {
  sequencerActive.set(false);

  // Reset success states
  sequence.update((s) => {
    for (let i = 0; i < s.length; i++) {
      s[i].success = true;
    }
    return s;
  });
}

export function clearSequencer() {
  sequence.set([]);
}

async function executeOperation(sequenceElement: SequenceElement) {
  if (sequenceElement) {
    playSound("eventGood", "ui");
    console.log("====> executing operation:", sequenceElement.operation.name);

    // Check operation requirements
    if (!sequenceElement.operation.requirement(sequenceElement.operation.costs)) return false;

    // Execute
    const tx = await sequenceElement.operation.execute();

    if (tx === false) return false;
    console.log(tx);

    const receipt: ContractReceipt = await tx.wait();
    console.log(receipt);

    return true;
  } else {
    stopSequencer();
    return false;
  }
}

blockNumber.subscribe(async (newBlock) => {
  if (get(player)) {
    // If the player be dead
    if (get(player).entityType == EntityType.Corpse) {
      uiState.alter("executor", "hidden", true);
      uiState.alter("compulsions", "hidden", true);
      uiState.close("executor");
      uiState.close("compulsions");
      return;
    }

    // If cooldown block changed
    if (get(player).coolDownBlock !== oldCoolDownBlock) {
      // Block to cooldown is (current block + 1) - cooldown block
      operationDuration.set((get(player).coolDownBlock || 0) - newBlock + 1);
      // Tween value down from operationDuration ...
      progress.set(get(operationDuration), { duration: 0 });
      // ... to 0 over operationDuration seconds
      progress.set(0, { duration: get(operationDuration) * 1000 });
      // Store cooldown block for future reference
      oldCoolDownBlock = get(player).coolDownBlock || 0;
    }

    // Set player state to idle if:
    // – the sequencer is not active
    // - Cooldown period is over
    if (!get(sequencerActive) && newBlock > (get(player).coolDownBlock || 0)) {
      playerActivity.set(Activities.Idle);
    }

    // Execute the next operation if
    // – Sequencer is active
    // - Cooldown period is over
    // - Arbitrary block delay
    if (get(sequencerActive) && newBlock > (get(player).coolDownBlock || 0) && blockDelay % 4 == 0) {
      activeOperationIndex.set(turnCounter % get(sequence).length);

      const currentSequenceElement = get(sequence)[get(activeOperationIndex)];
      const outcome = await executeOperation(currentSequenceElement);

      if (currentSequenceElement.operation.category === OperationCategory.Gate) {
        // If current operation is a gate
        // – proceed if returning true
        // – start from beginning if return false
        turnCounter = outcome ? turnCounter + 1 : 0;
      } else {
        turnCounter++;
      }

      sequence.update((s) => {
        if (s[get(activeOperationIndex)].operation.category !== OperationCategory.Gate) {
          s[get(activeOperationIndex)].success = outcome;
        }
        return s;
      });

      // Set player activity
      // if (outcome) {
      //   playerActivity.set(categoryToActivity(currentSequenceElement.operation.category));
      // }
    }

    blockDelay++;
  }
});
