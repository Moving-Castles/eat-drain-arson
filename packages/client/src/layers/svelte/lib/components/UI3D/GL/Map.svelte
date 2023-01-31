<script lang="ts">
  // TYPES
  import type { GridTile } from "../../UIGridMap";
  // GAME
  import { blockNumber } from "../../../../modules/network";
  import { playerAddress } from "../../../../modules/player";
  import { entities, getCores } from "../../../../modules/entities";
  // import { entities } from "../../../../modules/gamestate";
  import { initGrid, updateGrid } from "../../UIGridMap";
  // GL
  import { T } from "@threlte/core";
  import Camera from "./Camera.svelte";
  import Entity from "./entities/Entity.svelte";
  import Core from "./entities/Core.svelte";
  import Tile from "./Tile.svelte";
  // THREE
  import { DEG2RAD } from "three/src/math/MathUtils";

  const UNIT = 10;

  let grid: GridTile[] = [];

  grid = initGrid(UNIT);

  blockNumber.subscribe(async () => {
    grid = await updateGrid(grid);
  });
</script>

<!-- PLAYERS LAYER -->
<!-- <Player /> -->

<!-- BASE LAYER -->
<T.Group rotation.y={DEG2RAD * 45}>
  <!-- Floor -->
  {#each grid as tile (`${tile.coordinates.x}-${tile.coordinates.y}`)}
    <Tile {tile} />
  {/each}

  <!-- Entities -->
  {#each Object.entries($entities) as [id, entity] (id)}
    <!-- Your position in the world -->
    <Entity {id} {entity}>
      {#each getCores(id) as [coreId, coreEntity] (coreId)}
        <Core id={coreId} entity={coreEntity} />
      {/each}
    </Entity>
  {/each}
</T.Group>

<!-- LIGHTING AND FX -->
<!-- <T.AmbientLight intensity={1} /> -->
