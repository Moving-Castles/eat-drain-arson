<script lang="ts">
  import type { Coord } from "@latticexyz/utils";
  import { onMount } from "svelte";
  import { playerCore, multiCore } from "../../../modules/player";

  import TileInteract from "./UITileInteract.svelte";
  import DebugChat from "./UIDebugChat.svelte";
  import Tile from "./Tile.svelte";

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
    for (let y = 0; y < unit; y++) {
      for (let x = 0; x < unit; x++) {
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
  });

  function centerMapOnPlayer() {
    let playerEl = document.getElementsByClassName("player")[0];

    if (playerEl && playerEl.parentElement) {
      let playerTileEl = playerEl.parentElement;
      console.log(playerTileEl);
      console.log(playerTileEl.offsetLeft, playerTileEl.offsetTop);
      playerTileEl.scrollIntoView({ block: "center", inline: "center" });
    }
  }

  onMount(async () => {
    setTimeout(centerMapOnPlayer, 2000);
  });
</script>

{#if tileInteractActive}
  <TileInteract
    {selectedTileCoords}
    on:close={() => {
      tileInteractActive = false;
    }}
  />
{/if}

{#if $multiCore}
  <DebugChat channelId={$playerCore.carriedBy} />
{/if}

<div class="ui-debug-map">
  <div class="center-map-button"><button on:click={centerMapOnPlayer}>CENTER</button></div>

  <div class="map-container">
    <!-- GRID -->
    {#each grid as tile}
      <Tile
        {tile}
        on:interact={(e) => {
          selectedTileCoords = e.detail.selectedTileCoords;
          tileInteractActive = true;
        }}
      />
    {/each}
  </div>
</div>

<style>
  .center-map-button {
    position: fixed;
    top: 82px;
    left: 120px;
    z-index: 1000;
  }

  .ui-debug-map {
    height: 100%;
    width: 100%;
    overflow: auto;
    padding: 0;
  }

  .map-container {
    box-sizing: border-box;
    width: 3003px;
    height: 3003px;
    background: rgb(59, 58, 68);
    border: 1px solid white;
    position: relative;
  }
</style>
