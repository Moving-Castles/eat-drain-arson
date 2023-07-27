import type { SystemTypes } from "contracts/types/SystemTypes";
import { writable, get } from "svelte/store";
import { network, blockNumber } from "../network";

// --- TYPES -----------------------------------------------------------------

export enum SequencerState {
  Running,
  Paused,
}

export enum QueuedActionState {
  Queued,
}

export enum ActiveActionState {
  Sent,
}

export enum ProcessedActionState {
  Executed,
  Confirmed,
  Failed,
}

export type Action = {
  actionId: string;
  systemId: keyof SystemTypes;
  state?: QueuedActionState | ActiveActionState | ProcessedActionState;
  tx?: string;
  timestamp?: number;
  params?: any[];
};

// --- STORES -----------------------------------------------------------------

export const sequencerState = writable(SequencerState.Running);
export const queuedActions = writable([] as Action[]);
export const activeActions = writable([] as Action[]);
export const processedActions = writable([] as Action[]);

// --- API -----------------------------------------------------------------

export function addToSequencer(systemId: keyof SystemTypes, params: any[] = []) {
  queuedActions.update((queuedActions) => {
    const newAction = {
      actionId: self.crypto.randomUUID(),
      state: QueuedActionState.Queued,
      systemId: systemId,
      params: params,
    };
    return [...queuedActions, newAction];
  });
}

export function removeFromSequencer(id: string) {
  queuedActions.update((queuedActions) => queuedActions.filter((a) => a.actionId !== id));
}

export function clearSequencer() {
  queuedActions.update(() => []);
}

// --- SEQUENCER -----------------------------------------------------------------

export function initActionSequencer() {
  /*
   *   The sequencer triggers on each block
   *   If the conditions are met it executes the next action
   *   To be notified of the action being executed we listen to calls to all systems
   *
   */

  blockNumber.subscribe(async (newBlock) => {
    // Execute next if:
    // - sequencer is running
    // - there are no active action
    // - queue is not empty
    if (
      get(sequencerState) === SequencerState.Running &&
      get(activeActions).length === 0 &&
      get(queuedActions).length > 0
    ) {
      execute(newBlock);
    }
  });

  const EXCLUDED_SYSTEMS = ["system.ComponentDev", "system.Init", "system.Spawn"];

  // Set up listeners for all systems (except EXCLUDED_SYSTEMS)
  for (const [key, value] of Object.entries(get(network).systemCallStreams)) {
    if (!EXCLUDED_SYSTEMS.includes(key)) {
      value.subscribe((systemCall) => {
        const action = get(activeActions).find((a) => a.tx === systemCall.tx.hash);
        if (!action) return;
        // Remove action from active list
        activeActions.update((activeActions) => activeActions.filter((a) => a.tx !== action?.tx));
        // Add action to processed list
        processedActions.update((processedActions) => [action, ...processedActions]);
      });
    }
  }
}

async function execute(newBlock: number) {
  const action = get(queuedActions)[0];
  try {
    // Remove action from queue list
    queuedActions.update((queuedActions) => queuedActions.slice(1));
    // Add action to active list
    activeActions.update((activeActions) => [action, ...activeActions]);
    // @todo: fix types
    // let tx = await get(network).systems["system.Burn"].executeTyped(...action.params);
    const tx = await get(network).systems[action.systemId].executeTyped(...action.params);
    // Add tx hash and timestamp
    activeActions.update((activeActions) => {
      activeActions[0].tx = tx.hash;
      activeActions[0].timestamp = Date.now();
      return activeActions;
    });
  } catch (e) {
    window.alert(e);
    // Remove action from queue list
    queuedActions.update((queuedActions) => queuedActions.slice(1));
    // Add action to processed list
    processedActions.update((processedActions) => [action, ...processedActions]);
  }
}
