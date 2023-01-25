import type { Derived } from "svelte/store";
import { derived, writable, get } from "svelte/store";
import { tweened } from "svelte/motion";
import { network, blockNumber } from "../network";
import { isEqual } from "lodash";
import type { EntityType, Player } from "../entities";
import { EntityType, entities } from "../entities";

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

export const player = derived([entities, playerAddress], ([$entities, $playerAddress]) => {
  const p = $entities[$playerAddress];
  return p as Player;
});

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
export const playerEnergy = derived([player, blockNumber], ([$player, $blockNumber]) =>
  $player ? calculateEnergy($player, $blockNumber) : 0
);
export const heartbeats = derived([player, blockNumber], ([$player, $blockNumber]) =>
  $player && $blockNumber ? calculateHeartbeats($player, $blockNumber) : 0
);
export const dead = derived(player, ($player) => $player.energy < 1);
// Interpolation
export const playerPositionY = tweened(get(player)?.position?.y || 0, { duration: 10000 });
export const playerPositionX = tweened(get(player)?.position?.x || 0, { duration: 10000 });

// function makeInterpolated (entityStore: Derived, componentPath: 'string', duration: number) {
//   const v = get(entityStore)
//   console.log(v)
//   // console.log(componentPath)
//   const components = componentPath.split('.')
//   let initialValue = null

//   switch (components.length) {
//     case (1):
//       initialValue = v[components[0]]
//       break
//     case (2):
//       initialValue = v[components[0]][components[1]]
//       break
//     case (3):
//       initialValue = v[components[0]][components[1]][components[2]]
//       break
//     case (0):
//     default:
//       initialValue = v
//       break
//   }

//   return tweened(initialValue, { duration })
// }

// export const playerPositionX = makeInterpolated(player, 'position.x', 1000)

// --- FUNCTIONS -----------------------------------------------------------------

/**
 * Calculate the player's energy
 * @param $player
 * @param $blockNumber
 * @returns
 */
export function calculateEnergy($player: Player, $blockNumber: number) {
  if (parseInt(String($player.death)) <= $blockNumber) {
    return 0;
  }
  // actualEnergy = deathBlock - currentBlock
  return parseInt(String($player.death)) - $blockNumber;
}

export function calculateHeartbeats(player: Player, blockNumber: number) {
  const energy = calculateEnergy(player, blockNumber);
  const lifespan = parseInt(String(player.death)) - parseInt(String(player.birth));
  if (energy < 1) {
    return lifespan;
  } else {
    return lifespan + (blockNumber - parseInt(String(player.death)));
  }
}
