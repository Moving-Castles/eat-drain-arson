<script lang="ts">
  import type { GridTile } from "../index";
  import { initGrid, updateGrid } from "../index";

  import { DEG2RAD } from "three/src/math/MathUtils";
  import { T } from "@threlte/core";
  import Tile from "./Tile.svelte";

  let grid: GridTile[] = [];
</script>

<T.Group rotation.x={DEG2RAD * -90}>
  {#each grid as tile}
    <Tile {tile} />
  {/each}
</T.Group>
