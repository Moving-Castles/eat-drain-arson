import { get } from "svelte/store";
import { network } from "../../stores/network";
import { player, playerEnergy } from "../../stores/player";
import { directToLog, LogEntryType, getOperationTale } from "../../stores/narrative";

export function dig() {
  if ((get(playerEnergy) || 0) >= 100) {
    get(network).api?.gather(100);
    directToLog(getOperationTale("dig", "lore"), LogEntryType.Banter);
    return true;
  } else {
    directToLog("You do not have enough energy to do this", LogEntryType.Failure);
    return false;
  }
}
