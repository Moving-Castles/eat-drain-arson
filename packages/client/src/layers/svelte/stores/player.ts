import { derived, writable, get } from "svelte/store";
import { network, blockNumber } from "./network";
import { entities } from "./entities";
import { uniq } from "lodash";
import { seedToName } from "../utils/name";
import { Directions } from "../utils/space";

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

export const playerAddress = derived(network, ($network) => $network.network?.connectedAddress.get() || "0x0");

export const player = derived([entities, playerAddress], ([$entities, $playerAddress]) => {
  return $entities[$playerAddress];
});

export const playerActivity = writable(Activities.Idle);

export const playerDirection = writable(Directions.Random);

/**
 * Calculate the player's energy
 * @param $player
 * @param $blockNumber
 * @returns
 */
export function calculateEnergy($player, $blockNumber) {
  if (parseInt(String($player.death)) <= $blockNumber) {
    return 0;
  }
  // actualEnergy = deathBlock - currentBlock
  return parseInt(String($player.death)) - $blockNumber;
}

export const playerEnergy = derived([player, blockNumber], ([$player, $blockNumber]) => {
  if ($player) {
    return calculateEnergy($player, $blockNumber);
  }

  return 0;
});

// Input: an array of players, outputs, player names
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

/**
 * Are u ded?
 */
export const dead = derived(playerEnergy, ($e) => $e < 1);

export function calculateHeartbeats(player, blockNumber) {
  const energy = calculateEnergy(player, blockNumber);
  const lifespan = parseInt(String(player.death)) - parseInt(String(player.birth));
  if (energy < 1) {
    return lifespan;
  } else {
    return lifespan + (blockNumber - parseInt(String(player.death)));
  }
}

/**
 * 🫀
 */
export const heartbeats = derived([player, blockNumber], ([$p, $b]) => {
  if ($p && $b) {
    return calculateHeartbeats($p, $b);
  }

  return 0;
});
