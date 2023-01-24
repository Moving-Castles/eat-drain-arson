<script lang="ts">
  import { flip } from "svelte/animate";
  import { derived } from "svelte/store";
  import { cubicInOut as easing } from "svelte/easing";
  import { calculateHeartbeats, players } from "../../../modules/player";
  import { blockNumber } from "../../../modules/network";
  import { category } from "../../../modules/ui";
  import { seedToName } from "../../../utils/name";
  import { EntityType } from "../../../modules/entities";

  export let autoplay = 2500;
  // let interval;
  let i = 0;

  const rankedPlayers = derived([players, blockNumber], ([$players, $blockNumber]) => {
    const arr = [...Object.values($players)];
    arr.sort((a, b) => {
      return calculateHeartbeats(b, $blockNumber) - calculateHeartbeats(a, $blockNumber);
    });
    return arr;
  });
</script>

<div class="ui-stats">
  <div class="ranks">
    {#each $rankedPlayers as player, i (player.seed + i)}
      <div class="ui-stat-row">
        <span class="ui-stat-rank">{++i}</span>
      </div>
    {/each}
  </div>
  <div class="players">
    {#each $rankedPlayers as player, i (player.seed + i)}
      <div animate:flip={{ duration: 400, easing }} class="ui-stat-row">
        <span class:dead={player.entityType == EntityType.Corpse} class="ui-stat-player">{seedToName(player.seed)}</span
        >
      </div>
    {/each}
  </div>
  <div class="scores">
    {#each $rankedPlayers as player, i (player.seed + i)}
      <div class="ui-stat-row">
        <span>{calculateHeartbeats(player, $blockNumber)}</span>
      </div>
    {/each}
  </div>
</div>

<style>
  .ui-stats {
    display: flex;
    gap: 8px;
    padding-bottom: var(--row-gap);
  }
  .ui-categories {
    position: sticky;
    width: 100%;
    left: 0;
    top: 0;
    padding-bottom: 6px;
    background-color: var(--background);
    /* backdrop-filter: var(--backdrop);
    -webkit-backdrop-filter: var(--backdrop); */
    display: flex;
    justify-content: space-between;
  }
  .ui-category {
    opacity: var(--muted-opacity);
    cursor: pointer;
    text-align: center;
  }
  .ui-stat-row {
    height: var(--font-size-large);
  }

  .ui-stat-rank {
    /* text-align: right; */
    opacity: var(--muted-opacity);
  }

  .ui-stat-player {
    overflow: hidden;
    display: inline-block;
    white-space: nowrap;
  }

  .ui-stat-rank {
    width: 20px;
    display: inline-block;
  }

  .dead {
    text-decoration: line-through;
  }
</style>
