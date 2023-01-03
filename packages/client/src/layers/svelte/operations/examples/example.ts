import { get } from "svelte/store";
import { Operation, OperationCategory } from "../types";
import { checkCosts } from "../utils";
import { network } from "../../modules/network";
import { player } from "../../modules/player";
import { Directions } from "../../utils/space";

export const example: Operation = {
  name: "example",
  category: OperationCategory.Special,
  metadata: {
    description: "Example operation",
    errorMessage: "Operation failed",
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
