import { get } from "svelte/store";
import { player } from "../../stores/player";
import { EntityType } from "../../stores/entities";
import { Operation, OperationCategory } from "../types";
import { checkForType } from "../utils";

export const drained: Operation = {
  name: "drained?",
  category: OperationCategory.Gate,
  metadata: {
    description: "Has someone already drained all the sludge in this soil?",
    positiveMessage: "Nothing left.",
    negativeMessage: "Some sludge left.",
    errorMessage: "Gate failed",
  },
  costs: [],
  requirement: () => {
    const terrainInLocation = checkForType(get(player).position, EntityType.Terrain);
    return !terrainInLocation || (terrainInLocation.resource || 0) > 0 ? false : true;
  },
  execute: () => false,
};
