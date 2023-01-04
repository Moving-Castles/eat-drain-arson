<script lang="ts">
  import { Coord } from "@latticexyz/utils";
  import { createPerlin, Perlin } from "@latticexyz/noise";
  import { onMount } from "svelte";
  import UIGridTile from "./UIGridTile.svelte";
  import { GridTile } from "./index";
  import { entities, EntityType } from "../../../modules/entities";
  import { Activities, player, playerActivity, playerDirection } from "../../../modules/player";
  import { blockNumber } from "../../../modules/network";
  import { TerrainType, directionToString } from "../../../utils/space";
  import { seedToName } from "../../../utils/name";

  let perlin: Perlin;
  let w: Number;
  let h: Number;
  let shortest: Number;
  let unit = 7;

  const CLOSEST_ZOOM = 3;
  const FURTHEST_ZOOM = 49;

  function checkForType(gridPosition: Coord, type: EntityType) {
    let entity = Object.values($entities).find(
      (e) =>
        e.seed !== $player.seed &&
        (e.position?.x || 0) == gridPosition.x &&
        (e.position?.y || 0) == gridPosition.y &&
        e.entityType == type
    );
    return entity;
  }

  function perlinToTerrainType(p: number) {
    if (p < 0.4) return TerrainType.Dust;
    if (p < 0.6) return TerrainType.Debris;
    return TerrainType.Ruins;
  }

  let grid: GridTile[] = [];

  function initGrid() {
    for (let y = 0; y <= unit - 1; y++) {
      for (let x = 0; x <= unit - 1; x++) {
        let yVal = y - Math.floor(unit / 2);
        let xVal = x - Math.floor(unit / 2);

        let newGridTile: GridTile = {
          direction: ".",
          transformation: { x: xVal, y: yVal },
          coordinates: { x: 0, y: 0 },
          perlinFactor: 0,
          terrain: TerrainType.Dust,
          resource: 100,
        };
        grid = [...grid, newGridTile];
      }
    }
  }

  function updateGrid(centerPosition: Coord) {
    for (let i = 0; i < grid.length; i++) {
      grid[i].coordinates.x = (centerPosition?.x || 0) + grid[i].transformation.x;
      grid[i].coordinates.y = (centerPosition?.y || 0) + grid[i].transformation.y;
      grid[i].perlinFactor = perlin(grid[i].coordinates.x, grid[i].coordinates.y, 0, 20);
      grid[i].terrain = perlinToTerrainType(grid[i].perlinFactor);
      grid[i].fire = checkForType(grid[i].coordinates, EntityType.Fire);
      grid[i].other =
        checkForType(grid[i].coordinates, EntityType.Player) || checkForType(grid[i].coordinates, EntityType.Corpse);
      grid[i].corpse = checkForType(grid[i].coordinates, EntityType.Corpse);
      grid[i].mined = checkForType(grid[i].coordinates, EntityType.Terrain);
      grid[i].resource = grid[i].mined == undefined ? 100 : grid[i].mined.resource;
    }

    grid = [...grid];
  }

  blockNumber.subscribe(() => {
    if ($player) updateGrid($player.position);
  });

  onMount(async () => {
    perlin = await createPerlin();
    initGrid();
    if ($player) updateGrid($player.position);
  });

  $: shortest = Math.min(w, h);

  function handleZoom(e) {
    if (e.key === "-" && unit < FURTHEST_ZOOM) {
      unit += 2;
      console.log(unit);
      grid = [];
      initGrid();
    }
    if (e.key === "=" && unit > CLOSEST_ZOOM) {
      unit -= 2;
      console.log(unit);
      grid = [];
      initGrid();
    }
  }
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
