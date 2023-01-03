import { getRandomInt } from "../../utils/ui";
import { get } from "svelte/store";
import { Operation, OperationCategory } from "../types";
import { checkCosts } from "../utils";
import { network } from "../../modules/network";
import { player } from "../../modules/player";

export const gallop: Operation = {
  name: "gallop",
  category: OperationCategory.Move,
  metadata: {
    description: "Move 5 step in random direction",
    lore: [
      "You leave a trail of blood.",
      "Warm hearths for the sullen secret art, a lake of sludge to drown your heart",
      "One day you may touch the happy isles.",
    ],
    errorMessage: "Movement failed: not enough energy",
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
    return get(network).api?.move(50, getRandomInt(1, 8));
  },
};
