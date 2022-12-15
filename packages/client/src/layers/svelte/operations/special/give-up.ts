import { get } from "svelte/store";
import { network } from "../../stores/network";
import { player, playerEnergy } from "../../stores/player";
import { directToLog, getOperationTale, LogEntryType } from "../../stores/narrative";

export function giveUp() {
  // Spend all available energy moving in a random direction
  get(network).api?.move(get(playerEnergy) || 0, 0);
  directToLog(getOperationTale("give up", "lore"), LogEntryType.Banter);

  return true;
}
