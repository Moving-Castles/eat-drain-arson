<script lang="ts">
  import type { Coord } from "@latticexyz/utils";
  import { onMount } from "svelte";
  import { baseEntities, cores, items, untraversables, freePortables } from "../../../modules/entities";
  import { playerAddress, playerCore, multiCore } from "../../../modules/player";
  import { addressToColor } from "../../../utils/ui";
  import { network } from "../../../modules/network";

  import TileInteract from "./UITileInteract.svelte";
  import DebugChat from "./UIDebugChat.svelte";

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

  function pickUp(entityId: string) {
    $network.api.pickUp(entityId);
  }
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

        <!-- FREE PORTABLES -->
        <div class="free-portable-container">
          {#each Object.entries($freePortables) as [entityId, entity]}
            {#if entity.position.x == tile.coordinates.x && entity.position.y == tile.coordinates.y}
              <div
                class="free-portable"
                style={"background:" + addressToColor(entityId) + ";"}
                on:click={(e) => {
                  e.preventDefault();
                  pickUp(entityId);
                }}
              />
            {/if}
          {/each}
        </div>
      </div>
    {/each}

    <!-- BASE ENTITIES -->
    {#each Object.entries($baseEntities) as [entityId, entity]}
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
        <!-- ITEMS -->
        {#each Object.entries($items) as [coreEntityId, coreEntity]}
          {#if coreEntity.carriedBy == entityId}
            <div class="item" class:core={coreEntity.core} style={"background:" + addressToColor(coreEntityId) + ";"}>
              {#if coreEntityId === $playerAddress}*{/if}
            </div>
          {/if}
        {/each}
      </div>
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

  .untraversable {
    width: 50px;
    height: 50px;
    background: red;
    opacity: 0.5;
    position: absolute;
    display: flex;
    justify-content: center;
    align-items: center;
    cursor: not-allowed;
  }

  .item {
    width: 5px;
    height: 5px;
    display: flex;
    justify-content: center;
    align-items: center;
    color: black;
  }

  .free-portable {
    width: 10px;
    height: 10px;
    display: flex;
    justify-content: center;
    align-items: center;
    color: black;
    cursor: pointer;
    z-index: 10000;
  }

  .core {
    width: 10px;
    height: 10px;
    display: flex;
    justify-content: center;
    align-items: center;
    color: black;
  }
</style>
