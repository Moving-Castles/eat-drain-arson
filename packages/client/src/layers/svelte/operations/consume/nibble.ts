import { get } from "svelte/store";
import type { Operation } from "../types";
import { OperationCategory } from "../types";
import { checkCosts } from "../utils";
import { network } from "../../modules/network";
import { player } from "../../modules/player";

export const nibble: Operation = {
  name: "nibble",
  category: OperationCategory.Consume,
  metadata: {
    description: "Treat yourself, wet your tongue with a bit of sludge",
    lore: [
      "That should last you till nightfall.",
      "Your stomach turns, you throw up.",
      "Your tears add a little flavour to it.",
    ],
    errorMessage: "Consume failed: not enough resource",
  },
  costs: [
    {
      resource: 10,
    },
  ],
  requirement: (costs) => {
    if (!checkCosts(costs, get(player))) return false;
    return true;
  },
  execute: () => {
    return get(network).api?.consume(10);
  },
};
