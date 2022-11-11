import { get } from "svelte/store";
import { network, blockNumber } from "../../stores/network";
import { entities } from "../../stores/entities";
import { playerAddress } from "../../stores/player";

export function run() {
  if (get(entities)[get(playerAddress)].energy >= 5) {
    get(network).api?.move(5);
    return true;
  } else {
    console.log("Run: not enough energy");
    return false;
  }
}
