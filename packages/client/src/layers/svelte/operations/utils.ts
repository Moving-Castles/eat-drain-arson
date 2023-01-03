import { get } from "svelte/store";
import type { Cost } from "./types";
import type { Coord } from "@latticexyz/utils";
import { operations } from "./index";
import { Entity, entities, EntityType } from "../modules/entities";

export const checkCosts = (costs: Cost[], player: Entity) => {
  for (const [key, value] of Object.entries(costs)) {
    if (player[key] < value) return false;
  }
  return true;
};

export const checkForType = (gridPosition: Coord, type: EntityType) => {
  const entity = Object.values(get(entities)).find(
    (e) => (e.position?.x || 0) == gridPosition.x && (e.position?.y || 0) == gridPosition.y && e.entityType == type
  );
  return entity;
};

export const getOperation = (name: string) => {
  const result = operations.find((o) => o.name === name);
  if (!result) throw new Error("Operation Not Found");
  return result;
};
