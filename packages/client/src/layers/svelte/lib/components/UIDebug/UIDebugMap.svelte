<script lang="ts">
  import type { Coord } from "@latticexyz/utils";
  import { onMount } from "svelte";
  import { entities } from "../../../modules/entities";
  import { playerAddress, player, multiCore, playerCore } from "../../../modules/player";
  import { addressToColor } from "../../../utils/ui";

  import TileInteract from "./UITileInteract.svelte";
  import DebugChat from "./UIDebugChat.svelte";

  $: console.log($entities);

  let selectedTileCoords: Coord;
  let tileInteractActive = false;

  interface GridTile {
    direction: string;
    coordinates: Coord;
    perlinFactor: number;
    resource: number;
  }

  function initGrid(unit: number) {
    let grid = [] as GridTile[];
    for (let y = 0; y <= unit - 1; y++) {
      for (let x = 0; x <= unit - 1; x++) {
        const newGridTile: GridTile = {
          direction: ".",
          coordinates: { x: x, y: y },
          perlinFactor: 0,
          resource: 100,
        };
        grid = [...grid, newGridTile];
      }
    }

    return grid;
  }

  let grid: GridTile[] = [];

  onMount(async () => {
    grid = initGrid(10);
    console.log(grid);
  });
</script>

<div class="ui-debug-map">
  <div class="map-container">
    {#if tileInteractActive}
      <TileInteract
        {selectedTileCoords}
        on:close={() => {
          tileInteractActive = false;
        }}
      />
    {/if}

    <!-- GRID -->
    {#each grid as tile}
      <!-- svelte-ignore a11y-click-events-have-key-events -->
      <div
        class="tile"
        on:click={() => {
          selectedTileCoords = tile.coordinates;
          tileInteractActive = true;
        }}
      >
        <div>{tile.coordinates.x}:{tile.coordinates.y}</div>
      </div>
    {/each}
    <!-- BASE ENTITIES -->
    {#each Object.entries($entities) as [entityId, entity]}
      {#if entity.carryingCapacity}
        <div
          class="base-entity"
          style={"background:" +
            addressToColor(entityId) +
            "; left:" +
            (entity.position.x * 50 + 5) +
            "px; top:" +
            (entity.position.y * 50 + 5) +
            "px;"}
        >
          {#each Object.entries($entities) as [coreEntityId, coreEntity]}
            {#if coreEntity.core && coreEntity.carriedBy == entityId}
              <div class="core" style={"background:" + addressToColor(coreEntityId) + ";"}>
                {#if coreEntityId === $playerAddress}*{/if}
              </div>
            {/if}
          {/each}
        </div>
      {/if}
    {/each}
  </div>
</div>

{#if $multiCore}
  <DebugChat channelId={$playerCore.carriedBy} />
{/if}

<style>
  .ui-debug-map {
    display: flex;
    justify-content: center;
    align-items: center;
    height: 100%;
  }

  .map-container {
    box-sizing: border-box;
    width: 502px;
    height: 502px;
    background: rgb(59, 58, 68);
    border: 1px solid white;
    position: relative;
  }

  .tile {
    width: 50px;
    height: 50px;
    float: left;
    display: flex;
    justify-content: center;
    align-items: center;
    font-size: 8px;
    border: 1px solid white;
    cursor: pointer;
  }

  .tile:hover {
    background: rgb(70, 69, 81);
  }

  .base-entity {
    width: 40px;
    height: 40px;
    border-radius: 100%;
    position: absolute;
    display: flex;
    justify-content: center;
    align-items: center;
  }

  .core {
    width: 20px;
    height: 20px;
    display: flex;
    justify-content: center;
    align-items: center;
    color: black;
  }
</style>
