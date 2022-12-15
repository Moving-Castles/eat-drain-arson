import { get } from "svelte/store";
import { network } from "../../stores/network";
import { player, playerEnergy } from "../../stores/player";
import { directToLog, getOperationTale, LogEntryType } from "../../stores/narrative";

export function feast() {
  if ((get(player).resource || 0) >= 50) {
    get(network).api?.consume(50);
    directToLog(getOperationTale("feast", "lore"), LogEntryType.Banter);
    return true;
  } else {
    // directToLog(getOperationTale('feast', 'failure'), LogEntryType.Failure);
    console.log("Feast: not enough resource");
    return false;
  }
}
