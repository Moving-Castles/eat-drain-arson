import { get } from "svelte/store";
import { network } from "../../stores/network";
import { player, playerEnergy } from "../../stores/player";
import { directToLog, LogEntryType, getOperationTale } from "../../stores/narrative";
import { getRandomInt } from "../../utils/ui";

export function crawl() {
  if ((get(playerEnergy) || 0) >= 10) {
    get(network).api?.move(10, getRandomInt(1, 8));
    directToLog(getOperationTale("crawl", "lore"), LogEntryType.Banter);
    return true;
  } else {
    directToLog("You do not have enough energy to do this", LogEntryType.Failure);
    return false;
  }
}
