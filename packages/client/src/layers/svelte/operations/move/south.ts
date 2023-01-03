import { get } from "svelte/store";
import { Operation, OperationCategory } from "../types";
import { checkCosts } from "../utils";
import { network } from "../../modules/network";
import { player } from "../../modules/player";
import { Directions } from "../../utils/space";

export const south: Operation = {
  name: "south",
  category: OperationCategory.Move,
  metadata: {
    description: "Maybe this will save me from the cold.",
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
    return get(network).api?.move(10, Directions.South);
  },
};
