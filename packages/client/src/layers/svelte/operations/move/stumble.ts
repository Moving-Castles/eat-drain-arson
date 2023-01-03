import { getRandomInt } from "../../utils/ui";
import { get } from "svelte/store";
import { Operation, OperationCategory } from "../types";
import { checkCosts } from "../utils";
import { network } from "../../modules/network";
import { player } from "../../modules/player";

export const stumble: Operation = {
  name: "stumble",
  category: OperationCategory.Move,
  metadata: {
    description: "Move 3 step in random direction",
    lore: ["Are there others out there?", "Better than to stay and be absorbed.", "You still dream of the others."],
    errorMessage: "Movement failed: not enough energy",
  },
  costs: [
    {
      energy: 30,
    },
  ],
  requirement: (costs) => {
    if (!checkCosts(costs, get(player))) return false;
    return true;
  },
  execute: () => {
    return get(network).api?.move(30, getRandomInt(1, 8));
  },
};
