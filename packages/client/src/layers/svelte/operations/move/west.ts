import { get } from "svelte/store";
import { Operation, OperationCategory, checkCosts } from "../types";
import { network } from "../../stores/network";
import { player } from "../../stores/player";
import { Directions } from "../../utils/space";

export const west: Operation = {
  name: "west",
  category: OperationCategory.Move,
  metadata: {
    description: "If you want to go east, don't go west",
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
    return get(network).api?.move(10, Directions.West);
  },
};
