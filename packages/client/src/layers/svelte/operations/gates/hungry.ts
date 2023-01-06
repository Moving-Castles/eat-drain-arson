import { get } from "svelte/store";
import type { Operation } from "../types";
import { OperationType } from "../types";
import { player } from "../../modules/player";

export const hungry: Operation = {
  name: "hungry?",
  category: OperationType.Gate,
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
