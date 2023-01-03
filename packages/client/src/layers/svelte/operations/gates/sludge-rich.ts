import { get } from "svelte/store";
import { player } from "../../modules/player";
import { Operation, OperationCategory } from "../types";

export const sludgeRich: Operation = {
  name: "sludge rich?",
  category: OperationCategory.Gate,
  metadata: {
    description: "Are you carrying enough sludge to survive for a while?",
    positiveMessage: "It is almost full.",
    negativeMessage: "Not much there.",
    errorMessage: "Gate failed",
  },
  costs: [],
  requirement: () => {
    return (get(player).resource || 0) > 200 ? true : false;
  },
  execute: () => false,
};
