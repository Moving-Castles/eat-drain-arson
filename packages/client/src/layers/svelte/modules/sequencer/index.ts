import { writable, derived, get } from "svelte/store";
import { tweened } from "svelte/motion";
import type { Operation } from "../../operations/types";
import { OperationType } from "../../operations/types";
import type { ContractReceipt, ContractTransaction } from "ethers";
import { blockNumber } from "../network";
import { directToLog } from "../../modules/narrator";
import { player, playerActivity, Activities } from "../player";
import { range } from "../../utils/maths";

// --- TYPES -----------------------------------------------------------------

export type SequenceElement = {
  operation: Operation;
  success: boolean;
};

export enum State {
  Empty,
  Ready,
  StartingUp,
  ShuttingDown,
  Running,
  Error,
}

enum Event {
  Start,
  Run,
  Stop,
  Load,
  Clear,
  Finish,
  Error,
}

export const StateString = {
  [State.Empty]: "Empty",
  [State.Ready]: "Ready",
  [State.StartingUp]: "Starting up",
  [State.ShuttingDown]: "Shutting down",
  [State.Running]: "Running",
  [State.Error]: "Error",
};

// --- STORES -----------------------------------------------------------------

export const sequence = writable([] as SequenceElement[]);
export const sequencerState = writable(State.Empty);
export const activeOperationIndex = writable(0);
export const progress = tweened(0);
export const binaryProgress = tweened(0);
export const operationDuration = writable(0);
export const activeOperation = derived([sequence, activeOperationIndex], ([$s, $i]) => $s[$i]);

// --- CONSTANTS -----------------------------------------------------------------

export const emptySequenceElement: SequenceElement = {
  operation: {
    name: "+",
    category: OperationType.Empty,
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

// --- ..... -----------------------------------------------------------------

export function transition(state: State, event: Event) {
  switch (state) {
    case State.Empty:
      return emptyState(event);
    case State.Ready:
      return readyState(event);
    case State.StartingUp:
      return startingUpState(event);
    case State.Running:
      return runningState(event);
    case State.Executing:
      return executingState(event);
    case State.ShuttingDown:
      return shuttingDownState(event);
    default:
      return false;
  }
}

// __ Empty
// => Load
function emptyState(event: Event) {
  switch (event) {
    case Event.Load:
      sequencerState.set(State.Ready);
      return true;
    default:
      console.error("Invalid event:", event);
      return false;
  }
}

// __ Ready
// => Clear
// => Start
function readyState(event: Event) {
  switch (event) {
    case Event.Clear:
      sequencerState.set(State.Empty);
      return true;
    case Event.Start:
      sequencerState.set(State.StartingUp);
      return true;
    default:
      console.error("Invalid event:", event);
      return false;
  }
}

// __ StartingUp
// => Run
function startingUpState(event: Event) {
  switch (event) {
    case Event.Run:
      sequencerState.set(State.Running);
      return true;
    default:
      console.error("Invalid event:", event);
      return false;
  }
}

// __ ShuttingDown
// => Finish
function shuttingDownState(event: Event) {
  switch (event) {
    case Event.Finish:
      sequencerState.set(State.Ready);
      return true;
    default:
      console.error("Invalid event:", event);
      return false;
  }
}

// __ Running
// => Stop
// => Execute
function runningState(event: Event) {
  switch (event) {
    case Event.Stop:
      sequencerState.set(State.ShuttingDown);
      return true;
    default:
      console.error("Invalid event:", event);
      return false;
  }
}

// --- API -----------------------------------------------------------------

export function loadSequencer(newSequence: SequenceElement[]) {
  if (transition(get(sequencerState), Event.Load)) {
    sequence.set(newSequence);
  }
}

export function startSequencer() {
  if (transition(get(sequencerState), Event.Start)) {
    startListener();
  }
}

export function stopSequencer() {
  if (transition(get(sequencerState), Event.Stop)) {
    stopListener();
  }
}

export function clearSequencer() {
  if (transition(get(sequencerState), Event.Clear)) {
    sequence.set([]);
  }
}

// --- FUNCTIONS -----------------------------------------------------------------

async function startListener() {
  console.log("Starting listener...");
  transition(get(sequencerState), Event.Run);
}

async function stopListener() {
  console.log("Stopping listener...");
  transition(get(sequencerState), Event.Finish);
}

let oldCoolDownBlock = 0;
let turnCounter = 0;
let activeTransactions: ContractTransaction[] = [];

blockNumber.subscribe(async (newBlock) => {
  if (!get(player)) return false;

  // !! TODO: Move somewhere else
  // If cooldown block changed
  if (get(player).coolDownBlock !== oldCoolDownBlock) {
    // Blocks to cooldown is (current block + 1) - cooldown block
    operationDuration.set((get(player).coolDownBlock || 0) - newBlock + 1);
    // Tween value down from operationDuration ...
    progress.set(get(operationDuration), { duration: 0 });
    // ... to 0 over operationDuration seconds
    progress.set(0, { duration: get(operationDuration) * 1000 });

    // Tween value from 0 to 1
    // binaryProgress.set(0, { duration: 0 });
    // ... to 1
    // binaryProgress.set(1, { duration: get(operationDuration) * 1000 });

    // Store cooldown block for future reference
    oldCoolDownBlock = get(player).coolDownBlock || 0;
  }

  // !! TODO: Move somewhere else
  // Set player state to idle if:
  // – the sequencer is not running
  // - Cooldown period is over
  const playerIdle = get(sequencerState) !== State.Running && newBlock > (get(player).coolDownBlock || 0);

  if (playerIdle) {
    playerActivity.set(Activities.Idle);
  }

  // Execute the next operation if
  // – Sequencer is running
  // - Cooldown period is over
  // - The last transaction has been confirmed
  const executeNext =
    get(sequencerState) === State.Running &&
    newBlock > (get(player).coolDownBlock || 0) &&
    activeTransactions.length === 0;

  if (executeNext) {
    // Get current sequence element
    activeOperationIndex.set(turnCounter % get(sequence).length);
    const sequenceElement = get(sequence)[get(activeOperationIndex)];

    if (sequenceElement.operation.category === OperationType.Gate) {
      // For gates we only check the requirements
      // Proceed if true, start from beginning if false
      turnCounter = sequenceElement.operation.requirement(sequenceElement.operation.costs) ? turnCounter + 1 : 0;
    } else {
      // Check operation requirements
      if (sequenceElement.operation.requirement(sequenceElement.operation.costs)) {
        const tx = await sequenceElement.operation.execute();

        if (tx) {
          activeTransactions.push(tx);

          const receipt: ContractReceipt = await tx.wait();

          // Remove transaction from activeTransactions
          activeTransactions = activeTransactions.filter((tx) => tx.hash !== receipt.transactionHash);

          // !! TODO: Move somewhere else
          // Set player activity
          // if (outcome) {
          //   playerActivity.set(categoryToActivity(currentSequenceElement.operation.category));
          // }
        } else {
          console.error("transaction failed");
        }
      } else {
        // ...
        console.error("Operation: requirements failed");
      }

      turnCounter++;
    }
  }
});
