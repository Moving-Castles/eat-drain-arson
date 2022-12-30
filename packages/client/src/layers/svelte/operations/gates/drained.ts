import { Coord } from "@latticexyz/utils";
import { get } from "svelte/store";
import { player } from "../../stores/player";
import { entities, EntityType } from "../../stores/entities";
import { Operation, OperationCategory } from "../types";

function checkForType(gridPosition: Coord, type: EntityType) {
  const entity = Object.values(get(entities)).find(
    (e) => (e.position?.x || 0) == gridPosition.x && (e.position?.y || 0) == gridPosition.y && e.entityType == type
  );
  return entity;
}

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
