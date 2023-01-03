import { get } from "svelte/store";
import { Operation, OperationCategory } from "../types";
import { checkCosts } from "../utils";
import { network } from "../../modules/network";
import { player } from "../../modules/player";

export const dig: Operation = {
  name: "dig",
  category: OperationCategory.Gather,
  metadata: {
    description: "I can make use of this...",
    lore: [
      "Is this a tooth? What animal had teeth strong enough to survive the Big Juicification of the Old World?!",
      "A large larvae crawls into your lap and starts purring  <(°^°<0 …You squeeze it too hard. ",
      "The air smells of egg, it burns your nose, you get nostalgic, you once had an egg.",
    ],
    errorMessage: "Gather failed: not enough energy",
  },
  costs: [
    {
      energy: 100,
    },
  ],
  requirement: (costs) => {
    if (!checkCosts(costs, get(player))) return false;
    return true;
  },
  execute: () => {
    return get(network).api?.gather(100);
  },
};
