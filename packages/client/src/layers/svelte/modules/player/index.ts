import { derived, writable, get } from "svelte/store";
import { tweened } from "svelte/motion";
import { network, blockNumber } from "../network";
import type { EntityType, Player, Core, BaseEntity } from "../entities";
import { EntityType, entities, cores } from "../entities";

import { Directions } from "../../utils/space";

// --- TYPES -----------------------------------------------------------------

export enum Activities {
  Idle,
  Moving,
  Gathering,
  Eating,
  Burning,
  Playing,
  Dead,
}

export function categoryToActivity(category: string) {
  switch (category) {
    case "move":
      return Activities.Moving;
    case "gather":
      return Activities.Gathering;
    case "consume":
      return Activities.Eating;
    case "burn":
      return Activities.Burning;
    case "play":
      return Activities.Playing;
    case "dead":
      return Activities.Dead;
    default:
      return Activities.Idle;
  }
}

export function activityToVerb(activity: Activities) {
  switch (activity) {
    case Activities.Moving:
      return "walking";
    case Activities.Gathering:
      return "gathering";
    case Activities.Eating:
      return "eating";
    case Activities.Burning:
      return "making a fire";
    case Activities.Playing:
      return "playing";
    case Activities.Dead:
      return "dead";
    default:
      return "waiting";
  }
}

// --- STORES -----------------------------------------------------------------

export const playerAddress = derived(network, ($network) => $network.network?.connectedAddress.get() || "0x0");

// - L - E - G - A - C - Y -

export const player = derived([entities, playerAddress], ([$entities, $playerAddress]) => $entities[$playerAddress]);

export const playerEnergy = derived([player, blockNumber], ([$player, $blockNumber]) =>
  $player ? calculateEnergy($player, $blockNumber) : 0
);

// export const playerActivity = writable(Activities.Idle);
// export const playerDirection = writable(Directions.None);

// export const dead = derived(player, ($player) => $player.energy < 1);

// export const heartbeats = 0;

// - N - E- W

/**
 * The `core` is the agent of the player.
 *
 * A `core` controls any `baseEntity` it is carried by.
 *
 */
export const playerCore = derived(
  [entities, playerAddress],
  ([$entities, $playerAddress]) => $entities[$playerAddress] as Core
);

export const players = derived([entities, blockNumber], ([$entities, $blockNumber]) => {
  let ps = Object.entries($entities).filter(
    ([k, e]) => e.entityType == EntityType.Player || e.entityType == EntityType.Corpse
  );

  // Now double check for each one if they are dead
  ps = ps.map(([k, e]) => {
    const energy = calculateEnergy(e, $blockNumber);
    if (energy < 1) {
      e.entityType = EntityType.Corpse;
    } else if (e.entityType == EntityType.Corpse && energy > 0) {
      // Looks like you respawned, Padawan...
      e.entityType = EntityType.Player;
    }
    return [k, e];
  });

  return Object.fromEntries(ps);
});

/**
 * Other players
 */
export const others = derived([players, playerAddress], ([$players, $playerAddress]) =>
  Object.entries($players).filter(([k, e]) => k !== $playerAddress)
);

/**
 * Player properties
 */
export const playerActivity = writable(Activities.Idle);
export const playerDirection = writable(Directions.None);
export const heartbeats = derived([player, blockNumber], ([$player, $blockNumber]) =>
  $player && $blockNumber ? calculateHeartbeats($player, $blockNumber) : 0
);
export const dead = derived(player, ($player) => $player.energy < 1);
// Interpolation
export const playerPositionY = tweened(get(player)?.position?.y || 0, { duration: 10000 });
export const playerPositionX = tweened(get(player)?.position?.x || 0, { duration: 10000 });

/**
 * The `baseEntity` carrying the player's `core`
 *
 * A `baseEntity` is a "physical body" with position
 * and inventory. It can be controlled by any `core` it carries.
 *
 */
export const playerBaseEntity = derived([entities, playerCore], ([$entities, $playerCore]) => {
  if (!$entities || !$playerCore) return false;
  return $entities[$playerCore.carriedBy] as BaseEntity;
});

/**
 * Is the player's core sharing a baseEntity with other cores?
 */
export const multiCore = derived([cores, playerCore], ([$cores, $playerCore]) =>
  Object.values($cores).filter((e) => e.carriedBy == $playerCore.carriedBy).length > 1 ? true : false
);
