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

export const byAFire: Operation = {
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
    return checkForType(get(player).position, EntityType.Fire) ? true : false;
  },
  execute: () => false,
};
