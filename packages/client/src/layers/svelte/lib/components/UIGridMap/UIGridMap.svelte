<script lang="ts">
  import { initGrid, updateGrid } from "./index";
  import type { Coord } from "@latticexyz/utils";
  import type { GridTile } from "./index";
  import { onMount } from "svelte";
  import UIGridTile from "./UIGridTile.svelte";
  import { Activities, player, playerActivity, playerDirection } from "../../../modules/player";
  import { blockNumber } from "../../../modules/network";
  import { directionToString } from "../../../utils/space";
  import { seedToName } from "../../../utils/name";

  const CLOSEST_ZOOM = 3;
  const FURTHEST_ZOOM = 36;

  let w: Number;
  let h: Number;
  let shortest: Number;
  let unit = 7;

  let grid: GridTile[] = [];

  function handleZoom(e) {
    if (e.key === "-" && unit < FURTHEST_ZOOM) {
      unit += 2;
      grid = [];
      grid = initGrid(unit);
    }
    if (e.key === "=" && unit > CLOSEST_ZOOM) {
      unit -= 2;
      grid = [];
      grid = initGrid(unit);
    }
  }

  blockNumber.subscribe(async () => {
    if ($player) {
      grid = await updateGrid(grid);
    }
  });

  onMount(async () => {
    grid = initGrid(unit);
    if ($player) {
      grid = await updateGrid(grid);
    }
  });

  $: shortest = Math.min(w, h);
</script>

<svelte:window on:keypress={handleZoom} bind:innerHeight={h} />

{#if $player}
  <div style="--rows: {unit}; --cols: {unit}" class="ui-grid-map" bind:clientWidth={w}>
    <div class="grid-container overlay map" style:max-width="{shortest}px" style:max-height="{shortest}px">
      <!-- Shown if player is moving -->
      {#if $playerActivity == Activities.Moving && ($player.coolDownBlock || 0) > $blockNumber}
        <div class="cooldown-overlay">
          <div>
            <strong>{seedToName($player.seed || 0)}</strong> is moving
            <strong>{directionToString($playerDirection)}</strong>.<br />
            Arriving in <strong>{($player.coolDownBlock || 0) - $blockNumber}</strong> seconds
          </div>
        </div>
      {/if}

      {#each grid as tile}
        <UIGridTile {tile} />
      {/each}
    </div>
  </div>
{/if}

<style>
  .ui-grid-map {
    height: 100%;
    display: flex;
    flex-wrap: column;
    justify-content: center;
    align-items: center;
  }

  .grid-container {
    aspect-ratio: 1 / 1;
    width: 100%;
    height: 100%;
    max-width: 100%;
    max-height: 100%;
  }

  .grid-container {
    position: relative;
    display: grid;
    grid-template-columns: repeat(var(--cols), minmax(0, 1fr));
    grid-template-rows: repeat(var(--rows), minmax(0, 1fr));
    height: 100%;
  }
</style>
