import { get } from "svelte/store";
import { Operation, OperationCategory, checkCosts } from "../types";
import { network } from "../../stores/network";
import { player } from "../../stores/player";

export const collect: Operation = {
  name: "collect",
  category: OperationCategory.Gather,
  metadata: {
    description: "All I see are shrubs, leftovers and other bits",
    lore: [
      "fiberoptic shards cut your skin.",
      "you hum the old song as you scoop. ",
      `Frothproxy & twilight “|o|” / 
      He was the Old Wanderer / 
      The Stackdigger / 
      He took my twilight boi away/ 
      (˃̩̩̥ɷ˂̩̩̥)
      Oh, the old Stackdigger!”, you cry; the smog is so thick you cough, you swallow, you throw up. What a waste of sludge.`,
    ],
    errorMessage: "Gather failed: not enough energy",
  },
  costs: [
    {
      energy: 50,
    },
  ],
  requirement: (costs) => {
    if (!checkCosts(costs, get(player))) return false;
    return true;
  },
  execute: () => {
    return get(network).api?.gather(50);
  },
};
