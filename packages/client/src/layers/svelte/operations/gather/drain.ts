import { get } from "svelte/store";
import type { Operation } from "../types";
import { OperationCategory } from "../types";
import { checkCosts } from "../utils";
import { network } from "../../modules/network";
import { player } from "../../modules/player";

export const drain: Operation = {
  name: "drain",
  category: OperationCategory.Gather,
  metadata: {
    description: "Keep collecting before we run out",
    lore: [
      "Your tool hits something hard: some kind of fossilised relic in yellow and black, sth valuable, maybe commemorating sth. It’s covered in tooth marks. You give it a small lick. ",
      "Get sth to eat, dig a hole, find shelter. You feel really fucking lonely",
      "Take half/leave half, cut out one eye, give it a wash, leave it, they demand a sacrifice.",
    ],
    errorMessage: "Gather failed: not enough energy",
  },
  costs: [
    {
      energy: 200,
    },
  ],
  requirement: (costs) => {
    if (!checkCosts(costs, get(player))) return false;
    return true;
  },
  execute: () => {
    return get(network).api?.gather(200);
  },
};
