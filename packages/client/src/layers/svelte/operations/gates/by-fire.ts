import { get } from "svelte/store";
import { player } from "../../modules/player";
import { EntityCategory } from "../../modules/entities";
import type { Operation } from "../types";
import { OperationCategory } from "../types";
import { checkForType } from "../utils";

export const byFire: Operation = {
  name: "by a fire?",
  category: OperationCategory.Gate,
  metadata: {
    description: "Are you at a fire?",
    positiveMessage: "You arrived at a fire.",
    negativeMessage: "No fire in sight.",
    errorMessage: "Gate failed",
  },
  costs: [],
  requirement: () => {
    return checkForType(get(player).position, EntityCategory.Fire) ? true : false;
  },
  execute: () => false,
};
