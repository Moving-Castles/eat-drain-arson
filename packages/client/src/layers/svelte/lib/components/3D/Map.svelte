<script lang="ts">
  import type { GridTile } from "../UIGridMap/index";
  import { initGrid, updateGrid } from "../UIGridMap/index";
  import { textureSources, textures } from "./index";
  import { size } from "lodash";
  import { DEG2RAD } from "three/src/math/MathUtils";
  import { T, TransformableObject, useTexture, useFrame } from "@threlte/core";
  import { player } from "../../../modules/player";
  import { blockNumber } from "../../../modules/network";
  import { onMount, tick } from "svelte";

  /**
   * 3D Objects
   */
  import Tile from "./Tile.svelte";
  import Player from "./Player.svelte";

  let grid: GridTile[] = [];
  let rotation = DEG2RAD * 45;
  let unit = 49;
  let zoom = 240;
  let ready = false;
  let loaded = false;
  let texturesLoaded = 0;

  /**
   * Preload textures
   */
  $textures = useTexture(textureSources, {
    onLoad: (e) => {
      texturesLoaded++;
    },
  });

  $: loaded = texturesLoaded === size(textureSources);

  /**
   * Update grid based on the chain
   */
  blockNumber.subscribe(async () => {
    console.log($player.position);
    if ($player) {
      grid = await updateGrid($player.position, grid);
      ready = true;
    }
  });

  function handleZoom(e) {
    if (e.key === "-" && zoom > 40) {
      zoom -= 10;
    }
    if (e.key === "=" && zoom < 240) {
      zoom += 10;
    }
  }

  /**
   * Init
   */
  onMount(async () => {
    grid = initGrid(unit);
    if ($player) {
      grid = await updateGrid($player.position, grid);
      console.log($player.position);
      ready = true;
    }
  });

  // useFrame(() => (rotation += 0.002));
</script>

<svelte:window on:keypress={handleZoom} />

<T.Group rotation.y={rotation}>
  <T.OrthographicCamera {zoom} near={0.001} far={4000} let:ref={cam} position={[0, 10, 20]} makeDefault>
    <TransformableObject object={cam} lookAt={{ y: 1 }} />
  </T.OrthographicCamera>
</T.Group>

<Player />

{#if loaded && ready}
  <T.Group rotation.x={DEG2RAD * -90}>
    {#each grid as tile (`${tile.transformation.x}-${tile.transformation.y}`)}
      <Tile {tile} />
    {/each}
  </T.Group>
{/if}

<!-- <T.DirectionalLight position={[10, 10, 10]} intensity={0.2} look castShadow /> -->
<!-- <T.DirectionalLight position={[0, 10, -10]} intensity={0.2} /> -->
<!-- <T.AmbientLight intensity={1} /> -->
