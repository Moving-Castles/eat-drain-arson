import { getRandomInt } from "../../utils/ui";
import { get } from "svelte/store";
import type { Operation } from "../types";
import {} from "../types";
import { OperationCategory } from "../types";
import { checkCosts } from "../utils";
import { network } from "../../modules/network";
import { player } from "../../modules/player";

export const crawl: Operation = {
  name: "crawl",
  category: OperationCategory.Move,
  metadata: {
    description: "Move 1 step in random direction",
    lore: [
      "The smell is even stronger this close to the ground.",
      "Your cloth is becoming one with the soil.",
      "A brown recluse worm wraps itself around your ankle.",
    ],
    errorMessage: "Movement failed: not enough energy",
  },
  costs: [
    {
      energy: 10,
    },
  ],
  requirement: (costs) => {
    if (!checkCosts(costs, get(player))) return false;
    return true;
  },
  execute: () => {
    return get(network).api?.move(10, getRandomInt(1, 8));
  },
};
