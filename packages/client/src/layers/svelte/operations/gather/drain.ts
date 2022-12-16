import { get } from "svelte/store";
import { network } from "../../stores/network";
import { player, playerEnergy } from "../../stores/player";
import { directToLog, LogEntryType, getOperationTale } from "../../stores/narrative";

export function drain() {
  // if ((get(playerEnergy) || 0) >= 200) {
  get(network).api?.gather(500);
  // directToLog(getOperationTale("drain", "lore"), LogEntryType.Banter);
  return true;
  // } else {
  //   directToLog("You do not have enough energy to do this", LogEntryType.Failure);
  //   return false;
  // }
}
