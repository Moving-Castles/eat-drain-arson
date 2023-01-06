import { get } from "svelte/store";
import type { Operation } from "../types";
import { OperationType } from "../types";
import { checkCosts } from "../utils";
import { network } from "../../modules/network";
import { player } from "../../modules/player";

export const eat: Operation = {
  name: "eat",
  category: OperationType.Consume,
  metadata: {
    description: "Decent portion, like grandma used to make it.",
    lore: [
      "Why does the soil seem uneasy today?",
      "Your third arm still cradles the small leech",
      "Pray the Arteries will grant you your wish.",
    ],
    errorMessage: "Consume failed: not enough resource",
  },
  costs: [
    {
      resource: 25,
    },
  ],
  requirement: (costs) => {
    if (!checkCosts(costs, get(player))) return false;
    return true;
  },
  execute: () => {
    return get(network).api?.consume(25);
  },
};
