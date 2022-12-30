import type { Operation } from "./types";
import {
  crawl,
  stumble,
  gallop,
  east,
  west,
  north,
  south,
  southEast,
  southWest,
  northEast,
  northWest,
  goTowardsFire,
} from "./move";
import { collect, dig, drain } from "./gather";
import { nibble, eat, feast } from "./consume";
import { fire } from "./burn";
import { serenade } from "./play";
import { giveUp } from "./special";
import { hungry, sludgeRich, drained, byAFire } from "./gates";

export const operations: Operation[] = [
  // --- MOVE
  crawl,
  stumble,
  gallop,
  east,
  west,
  north,
  south,
  southEast,
  southWest,
  northEast,
  northWest,
  goTowardsFire,
  // --- GATHER
  collect,
  dig,
  drain,
  // --- CONSUME
  nibble,
  eat,
  feast,
  // --- BURN
  fire,
  // --- PLAY
  serenade,
  // --- SPECIAL
  giveUp,
  // --- GATE
  hungry,
  sludgeRich,
  drained,
  byAFire,
];

export const getOperation = (name: string) => {
  const result = operations.find((o) => o.name === name);
  if (!result) throw new Error("Operation Not Found");
  return result;
};
