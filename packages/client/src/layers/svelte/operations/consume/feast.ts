import { get } from "svelte/store";
import { Operation, OperationCategory } from "../types";
import { checkCosts } from "../utils";
import { network } from "../../stores/network";
import { player } from "../../stores/player";

export const feast: Operation = {
  name: "feast",
  category: OperationCategory.Consume,
  metadata: {
    description: "Deep gulps, if you throw up, dw, just drink it again <3",
    lore: ["For another day on this earth!", "Weather, walk with me!", "In deep they rest, glory to those who rest!"],
    errorMessage: "Consume failed: not enough resource",
  },
  costs: [
    {
      resource: 50,
    },
  ],
  requirement: (costs) => {
    if (!checkCosts(costs, get(player))) return false;
    return true;
  },
  execute: () => {
    return get(network).api?.consume(50);
  },
};
