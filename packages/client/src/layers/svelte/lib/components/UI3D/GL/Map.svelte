<script lang="ts">
  // TYPES
  import type { GridTile } from "../../UIGridMap";
  // GAME
  import { blockNumber } from "../../../../modules/network";
  import { entities, getCores } from "../../../../modules/entities";
  import { initGrid, updateGrid } from "../../UIGridMap";
  // GL
  import { T } from "@threlte/core";
  import Camera from "./Camera.svelte";
  import BaseEntity from "./entities/BaseEntity.svelte";
  import Core from "./entities/Core.svelte";
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
<T.Group position.x={-5} position.z={-5}>
  <!-- Floor -->
  {#each grid as tile (`${tile.coordinates.x}-${tile.coordinates.y}`)}
    <Tile {tile} />
  {/each}

  <!-- Entities -->
  {#each Object.entries($entities) as [id, entity] (id)}
    {#if entity.carryingCapacity}
      <!-- Your position in the world -->
      <BaseEntity {id} {entity}>
        {#each getCores(id) as [coreId, coreEntity] (coreId)}
          <Core id={coreId} entity={coreEntity} />
        {/each}
      </BaseEntity>
    {/if}
  {/each}
</T.Group>

<!-- LIGHTING AND FX -->
<!-- <T.AmbientLight intensity={1} /> -->
