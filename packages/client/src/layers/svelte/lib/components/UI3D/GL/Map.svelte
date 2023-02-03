<script lang="ts">
  // TYPES
  import type { GridTile } from "../../UIGridMap";
  // GAME
  import { blockNumber } from "../../../../modules/network";
  import { playerAddress } from "../../../../modules/player";
  import { entities } from "../../../../modules/entities";
  // import { entities } from "../../../../modules/gamestate";
  import { initGrid, updateGrid } from "../../UIGridMap";
  // GL
  import { T } from "@threlte/core";
  import Camera from "./Camera.svelte";
  import Entity from "./entities/Entity.svelte";
  import Core from "./entities/Core.svelte";
  import Tile from "./Tile.svelte";
  import Background from "./Background.svelte";
  // THREE
  import { DEG2RAD } from "three/src/math/MathUtils";
  import { MeshBasicMaterial } from "three";
  import { createEventDispatcher } from "svelte";

  const dispatch = createEventDispatcher();

  let tl = false;
  let bl = false;

  const UNIT = 10;

  let grid: GridTile[] = [];

  grid = initGrid(UNIT);

  const tileLoaded = () => (tl = true);
  const bgLoaded = () => (bl = true);

  blockNumber.subscribe(async () => {
    grid = await updateGrid(grid);
  });

  $: if (tl && bl) {
    dispatch("load");
  }
</script>

<!-- BASE LAYER -->
<T.Group>
  <!-- Sides -->
  <T.Group position.x={5} position.z={5}>
    <Background on:load={bgLoaded} />
  </T.Group>

  <!-- Floor -->
  {#each grid as tile (`${tile.coordinates.x}-${tile.coordinates.y}`)}
    <Tile {tile} on:load={tileLoaded} />
  {/each}

  <!-- Entities -->
  {#each Object.entries($entities) as [id, entity] (id)}
    <Entity {id} {entity} />
  {/each}
</T.Group>
