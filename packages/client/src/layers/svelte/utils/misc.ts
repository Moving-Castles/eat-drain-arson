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
