import { Coord } from "@latticexyz/utils";
import { writable, get, derived } from "svelte/store";
import { network, blockNumber } from "../network";
import { calculateEnergy } from "../player";
import { uniq } from "lodash";
import { seedToName } from "../../utils/name";

// --- TYPES -----------------------------------------------------------------

export enum EntityType {
  Player,
  Terrain,
  Fire,
  Corpse,
  Ghost,
}

export type StatsType = {
  traveled: number;
  gathered: number;
  burnt: number;
  eaten: number;
};

export type Player = {
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

export type Corpse = {
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

export type Ghost = {
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

export type Terrain = {
  entityType: EntityType.Terrain;
  position: Coord;
  resource: number;
};

export type Fire = {
  entityType: EntityType.Fire;
  position: Coord;
  coolDownBlock?: number;
  creator: string[];
  resource: number;
  seed: number;
};

export type Entity = Player | Terrain | Fire | Corpse | Ghost;

export type Entities = {
  [index: string]: Entity;
};

// --- STORES -----------------------------------------------------------------

export const entities = writable({} as Entities);

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
export const playersV2 = derived(
  entities,
  ($entities) =>
    Object.fromEntries(Object.entries($entities).filter(([v, e]) => e.entityType == EntityType.Player)) as Entities
);

export const firesV2 = derived(
  entities,
  ($entities) =>
    Object.fromEntries(Object.entries($entities).filter(([v, e]) => e.entityType == EntityType.Fire)) as Entities
);

export const terrainsV2 = derived(
  entities,
  ($entities) =>
    Object.fromEntries(Object.entries($entities).filter(([v, e]) => e.entityType == EntityType.Terrain)) as Entities
);

export const corpsesV2 = derived(
  entities,
  ($entities) =>
    Object.fromEntries(Object.entries($entities).filter(([v, e]) => e.entityType == EntityType.Corpse)) as Entities
);

// --- FUNCTIONS -----------------------------------------------------------------

export const indexToID = (index: number) => {
  return get(network).world?.entities[index];
};

/**
 * Format player list
 * @param Array of player names
 * @returns formatted string of names
 */
export function playerList(players: string[]) {
  const playerNames = players.map((p) => (get(entities)[p] ? seedToName(get(entities)[p].seed) : "not-found"));

  for (let i = 0; i < playerNames.length; i++) {
    if (playerNames[i] === seedToName(get(player).seed || 0)) {
      playerNames[i] += " (you)";
    }
  }

  // HACK: should make sure that the creator array on contract level is unique instead...
  return uniq(playerNames).join(", ");
}
