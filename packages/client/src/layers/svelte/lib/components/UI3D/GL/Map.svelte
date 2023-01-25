<script lang="ts">
  import { blockNumber } from "../../../../modules/network";
  import type { GridTile } from "../../UIGridMap";
  import { initGrid, updateGrid } from "../../UIGridMap";
  import { T } from "@threlte/core";
  import Camera from "./Camera.svelte";
  import Player from "./Player.svelte";
  import Tile from "./Tile.svelte";

  let grid: GridTile[] = [];

  grid = initGrid(10);

  blockNumber.subscribe(async () => {
    grid = await updateGrid(grid);
  });
</script>

<!-- CAMERA -->
<Camera />

<!-- PLAYERS LAYER -->
<!-- <Player /> -->

<!-- BASE LAYER -->
<T.Group>
  {#each grid as tile (`${tile.coordinates.x}-${tile.coordinates.y}`)}
    <Tile {tile} />
  {/each}
</T.Group>

<!-- LIGHTING AND FX -->
<T.AmbientLight intensity={1} />
