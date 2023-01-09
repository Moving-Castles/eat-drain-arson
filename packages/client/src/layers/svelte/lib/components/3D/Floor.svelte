<script lang="ts">
  import type { GridTile } from "../index";
  import { T } from "@threlte/core";
  import Tile from "./Tile.svelte";

  let grid: GridTile[] = [];
</script>

<T.Group>
  {#each grid as tile}
    <Tile {tile} />
  {/each}
</T.Group>
