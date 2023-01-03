import { get } from "svelte/store";
import { Operation, OperationCategory } from "../types";
import { checkCosts } from "../utils";
import { network } from "../../modules/network";
import { player } from "../../modules/player";
import { Directions } from "../../utils/space";

export const north: Operation = {
  name: "north",
  category: OperationCategory.Move,
  metadata: {
    description: "Fist of the north star",
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
    return get(network).api?.move(10, Directions.North);
  },
};
