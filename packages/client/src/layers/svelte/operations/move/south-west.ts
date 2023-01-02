import { get } from "svelte/store";
import { Operation, OperationCategory } from "../types";
import { checkCosts } from "../utils";
import { network } from "../../stores/network";
import { player } from "../../stores/player";
import { Directions } from "../../utils/space";

export const southWest: Operation = {
  name: "south-west",
  category: OperationCategory.Move,
  metadata: {
    description: "Move south west",
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
    return get(network).api?.move(10, Directions.SouthWest);
  },
};
