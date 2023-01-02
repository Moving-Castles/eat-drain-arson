import { Coord } from "@latticexyz/utils";
import { writable, get, derived } from "svelte/store";
import { network, blockNumber } from "./network";
import { calculateEnergy } from "./player";

export enum EntityType {
  Player,
  Terrain,
  Fire,
  Corpse,
  Ghost,
}

export interface StatsType {
  traveled: number;
  gathered: number;
  burnt: number;
  eaten: number;
}

type Player = {
  entityType: EntityType.Player;
  position: Coord;
  coolDownBlock: number;
  energy: number;
  resource: number;
  seed: number;
  stats: StatsType;
  birth: number;
  death: number;
  cannibal: string[];
  playing: number;
};

type Terrain = {
  entityType: EntityType.Terrain;
  position: Coord;
  resource: number;
};

type Fire = {
  entityType: EntityType.Fire;
  position: Coord;
  coolDownBlock?: number;
  creator: string[];
  resource: number;
  seed: number;
};

type Corpse = {
  entityType: EntityType.Corpse;
  position: Coord;
  coolDownBlock: number;
  energy: number;
  resource: number;
  seed: number;
  stats: StatsType;
  birth: number;
  death: number;
  cannibal: string[];
  playing: number;
};

type Ghost = {
  entityType: EntityType.Ghost;
  position: Coord;
  coolDownBlock: number;
  energy: number;
  resource: number;
  seed: number;
  stats: StatsType;
  birth: number;
  death: number;
  cannibal: string[];
  playing: number;
};

export type Entity = Player | Terrain | Fire | Corpse | Ghost;

export interface Entities {
  [index: string]: Entity;
}

export const entities = writable({} as Entities);

export const indexToID = (index: number) => {
  return get(network).world?.entities[index];
};

// Arrays
export const players = derived([entities, blockNumber], ([$entities, $blockNumber]) => {
  let ps = Object.values($entities).filter(
    (e) => e.entityType == EntityType.Player || e.entityType == EntityType.Corpse
  ) as ArrayLike<Entity>;

  // Now double check for each one if they are dead
  ps = ps.map((p) => {
    const energy = calculateEnergy(p, $blockNumber);
    if (energy < 1) {
      p.entityType = EntityType.Corpse;
    } else if (p.entityType == EntityType.Corpse && energy > 0) {
      // Looks like you respawned, Padawan...
      p.entityType = EntityType.Player;
    }
    return p;
  });

  return ps;
});
export const fires = derived(entities, ($entities) =>
  Object.values($entities).filter((e) => {
    return e.entityType == EntityType.Fire;
  })
);
export const terrains = derived(
  entities,
  ($entities) => Object.values($entities).filter((e) => e.entityType == EntityType.Terrain) as ArrayLike<Entity>
);
export const corpses = derived(
  entities,
  ($entities) => Object.values($entities).filter((e) => e.entityType == EntityType.Corpse) as ArrayLike<Entity>
);

// Objects
export const playersV2 = derived(entities, ($entities) =>
  Object.fromEntries(Object.entries($entities).filter(([v, e]) => e.entityType == EntityType.Player))
);
export const firesV2 = derived(entities, ($entities) =>
  Object.fromEntries(Object.entries($entities).filter(([v, e]) => e.entityType == EntityType.Fire))
);
export const terrainsV2 = derived(entities, ($entities) =>
  Object.fromEntries(Object.entries($entities).filter(([v, e]) => e.entityType == EntityType.Terrain))
);
export const corpsesV2 = derived(entities, ($entities) =>
  Object.fromEntries(Object.entries($entities).filter(([v, e]) => e.entityType == EntityType.Corpse))
);
