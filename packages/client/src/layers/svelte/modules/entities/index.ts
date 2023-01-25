import type { Coord } from "@latticexyz/utils";
import { writable, get, derived } from "svelte/store";
import { network } from "../network";
// import { player } from "../player";
import { uniq } from "lodash";
import { seedToName } from "../../utils/name";

// --- TYPES -----------------------------------------------------------------

export type Entity = {
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
  ) as Entities;
});

// --- FUNCTIONS -----------------------------------------------------------------

export const indexToID = (index: number) => {
  return get(network).world?.entities[index];
};

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
