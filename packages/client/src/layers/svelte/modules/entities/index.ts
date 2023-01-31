import type { Coord } from "@latticexyz/utils";
import { writable, get, derived } from "svelte/store";
import type { GameConfig } from "../../../network/config";
import { network } from "../network";

// --- TYPES -----------------------------------------------------------------

export type GameConfig = {
  worldHeight: number;
  worldWidth: number;
  initialEnergy: number;
  matterPerTile: number;
  defaultCarryingCapacity: number;
  moveCost: number;
  extractCost: number;
  transferCost: number;
};

export type Entity = {
  gameConfig?: GameConfig;
  creationBlock?: number;
  readyBlock?: number;
  matter?: number;
  energy?: number;
  position?: Coord;
  portable?: boolean;
  carryingCapacity?: number;
  core?: boolean;
  carriedBy?: string;
  inventory?: string[];
  abilityMove?: boolean;
  abilityConsume?: boolean;
  abilityExtract?: boolean;
  untraversable?: boolean;
};

export type Core = {
  core: true;
  portable: true;
  creationBlock: number;
  readyBlock: number;
  energy: number;
  carriedBy: string;
};

export type BaseEntity = {
  position: Coord;
  carryingCapacity: number;
  inventory: string[];
};

export type Resource = {
  matter: number;
  position: Coord;
};

export type SubstanceBlock = {
  matter: number;
  substance: number;
  portable: true;
  position?: Coord;
  carriedBy?: string;
};

export type Item = {
  portable: true;
  position?: Coord;
  carriedBy?: string;
  abilityMove?: boolean;
  abilityConsume?: boolean;
  abilityExtract?: boolean;
};

export type Untraversable = {
  untraversable: true;
  position: Coord;
};

export type FreePortable = {
  portable: true;
  position: Coord;
  substance?: number;
  matter?: number;
  abilityMove?: boolean;
  abilityConsume?: boolean;
  abilityExtract?: boolean;
};

// - - - -

export type Entities = {
  [index: string]: Entity;
};

export type Cores = {
  [index: string]: Core;
};

export type BaseEntities = {
  [index: string]: BaseEntity;
};

export type Resources = {
  [index: string]: Resource;
};

export type SubstanceBlocks = {
  [index: string]: SubstanceBlock;
};

export type Items = {
  [index: string]: Item;
};

export type Untraversables = {
  [index: string]: Untraversable;
};

export type FreePortables = {
  [index: string]: FreePortable;
};

// --- STORES -----------------------------------------------------------------

export const entities = writable({} as Entities);

export const cores = derived(entities, ($entities) => {
  return Object.fromEntries(Object.entries($entities).filter(([key, entity]) => entity.core)) as Cores;
});

export const baseEntities = derived(entities, ($entities) => {
  return Object.fromEntries(
    Object.entries($entities).filter(([key, entity]) => entity.carryingCapacity)
  ) as BaseEntities;
  // @todo add inventory array to entities
});

export const resources = derived(entities, ($entities) => {
  return Object.fromEntries(
    Object.entries($entities).filter(([key, entity]) => entity.matter && !entity.portable)
  ) as Resources;
});

export const substanceBlocks = derived(entities, ($entities) => {
  return Object.fromEntries(
    Object.entries($entities).filter(([key, entity]) => entity.matter && entity.portable)
  ) as SubstanceBlocks;
});

export const freePortables = derived(entities, ($entities) => {
  return Object.fromEntries(
    Object.entries($entities).filter(([key, entity]) => entity.portable && entity.position)
  ) as FreePortables;
});

export const items = derived(entities, ($entities) => {
  return Object.fromEntries(Object.entries($entities).filter(([key, entity]) => entity.portable)) as SubstanceBlocks;
});

export const untraversables = derived(entities, ($entities) => {
  return Object.fromEntries(
    Object.entries($entities).filter(([key, entity]) => entity.untraversable)
  ) as Untraversables;
});

// --- FUNCTIONS -----------------------------------------------------------------

export const indexToID = (index: number) => {
  return get(network).world?.entities[index];
};

export const getCores = (address: string) =>
  Object.entries(get(entities)).filter(([id, ent]) => ent.core && ent.carriedBy === address);

/**
 * Format player list
 * @param Array of player names
 * @returns formatted string of names
 */
// export function playerList(players: string[]): string {
//   const playerNames = players.map((p) => (get(entities)[p] ? seedToName(get(entities)[p].seed) : "not-found"));

//   for (let i = 0; i < playerNames.length; i++) {
//     if (playerNames[i] === seedToName(get(player).seed || 0)) {
//       playerNames[i] += " (you)";
//     }
//   }

//   // HACK: should make sure that the creator array on contract level is unique instead...
//   return uniq(playerNames).join(", ");
// }

// - L - E - G - A - C - Y -

export enum EntityType {
  Player,
  Terrain,
  Fire,
  Corpse,
  Ghost,
}

export const fires = derived(entities, ($entities) => {
  return Object.fromEntries(Object.entries($entities).filter(([key, entity]) => entity.core)) as Cores;
});

export const players = derived(entities, ($entities) => {
  return Object.fromEntries(Object.entries($entities).filter(([key, entity]) => entity.core)) as Cores;
});
