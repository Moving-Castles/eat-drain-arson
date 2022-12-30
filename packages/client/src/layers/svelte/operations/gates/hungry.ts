import { get } from "svelte/store";
import { Operation, OperationCategory } from "../types";
import { player } from "../../stores/player";

export const hungry: Operation = {
  name: "hungry?",
  category: OperationCategory.Gate,
  metadata: {
    description: "Are you hungry?",
    positiveMessage: "You are hungry.",
    negativeMessage: "You are not hungry.",
    errorMessage: "Gate failed",
  },
  costs: [],
  requirement: () => {
    return (get(player).energy || 0) < 100 ? true : false;
  },
  execute: () => false,
};
