import { derived, writable } from "svelte/store";
import { network } from "../network";
import type { Core, BaseEntity } from "../entities";
import { entities, cores } from "../entities";
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

/**
 * The `baseEntity` carrying the player's `core`
 *
 * A `baseEntity` is a "physical body" with position
 * and inventory. It can be controlled by any `core` it carries.
 *
 */
export const playerBaseEntity = derived(
  [entities, playerCore],
  ([$entities, $playerCore]) => $entities[$playerCore.carriedBy] as BaseEntity
);

/**
 * Is the player's core sharing a baseEntity with other cores?
 */
export const multiCore = derived([cores, playerCore], ([$cores, $playerCore]) =>
  Object.values($cores).filter((e) => e.carriedBy == $playerCore.carriedBy).length > 1 ? true : false
);

// - L - E - G - A - C - Y -

export const player = derived([entities, playerAddress], ([$entities, $playerAddress]) => $entities[$playerAddress]);

export const playerActivity = writable(Activities.Idle);
export const playerDirection = writable(Directions.None);

export const dead = derived(player, ($player) => $player.energy < 1);

// export const playerEnergy = derived([player, blockNumber], ([$player, $blockNumber]) =>
//   $player ? calculateEnergy($player, $blockNumber) : 0
// // );
// export const heartbeats = derived([player, blockNumber], ([$player, $blockNumber]) =>
//   $player && $blockNumber ? calculateHeartbeats($player, $blockNumber) : 0
// );

export const heartbeats = 0;
