import type { Cost } from "./types";
import type { Entity } from "../modules/entities";
import type { Coord } from "@latticexyz/utils";
import { get } from "svelte/store";
import { operations } from "./index";
import { entities, EntityCategory } from "../modules/entities";

export const checkCosts = (costs: Cost[], player: Entity) => {
  for (const [key, value] of Object.entries(costs)) {
    if (player[key] < value) return false;
  }
  return true;
};

export const checkForType = (gridPosition: Coord, type: EntityCategory) => {
  const entity = Object.values(get(entities)).find(
    (e) => (e.position?.x || 0) == gridPosition.x && (e.position?.y || 0) == gridPosition.y && e.entityCategory == type
  );
  return entity;
};

export const getOperation = (name: string) => {
  const result = operations.find((o) => o.name === name);
  if (!result) throw new Error("Operation Not Found");
  return result;
};
