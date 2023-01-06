<script lang="ts">
  import { initGrid, updateGrid } from "../index";
  import { textureSources, textures } from "./index";
  import { size } from "lodash";
  import type { GridTile } from "../index";
  import { T, TransformableObject, useTexture, useFrame } from "@threlte/core";
  import { player } from "../../../../modules/player";
  import { blockNumber } from "../../../../modules/network";
  import Tile from "./Tile.svelte";
  import { onMount, tick } from "svelte";

  let grid: GridTile[] = [];
  let rotation = 0;
  let unit = 49;
  let zoom = 49;
  let ready = false;
  let loaded = false;
  let texturesLoaded = 0;

  /**
   * Preload textures
   */
  $textures = useTexture(textureSources, {
    onLoad: (e) => {
      texturesLoaded++;
      console.log(texturesLoaded);
    },
  });

  $: loaded = texturesLoaded === size(textureSources);

  /**
   * Update grid based on the chain
   */
  blockNumber.subscribe(async () => {
    if ($player) {
      grid = await updateGrid($player.position, grid);
      ready = true;
    }
  });

  function handleZoom(e) {
    if (e.key === "-") {
      zoom -= 1;
    }
    if (e.key === "=") {
      zoom += 1;
    }
  }

  /**
   * Init
   */
  onMount(async () => {
    grid = initGrid(unit);
    if ($player) {
      grid = await updateGrid($player.position, grid);
      ready = true;
    }
  });

  useFrame(() => (rotation += 0.002));
</script>

<svelte:window on:keypress={handleZoom} />

<T.Group rotation.z={rotation}>
  <T.OrthographicCamera {zoom} far={4000} let:ref={cam} position={[0, 15, 10]} makeDefault>
    <TransformableObject object={cam} lookAt={{ y: 1 }} />
  </T.OrthographicCamera>
</T.Group>

{#if loaded && ready}
  <T.Group>
    {#each grid as tile}
      <Tile {tile} />
    {/each}
  </T.Group>
{/if}

<T.DirectionalLight position={[0, 10, 10]} castShadow />
<T.DirectionalLight position={[0, 10, -10]} intensity={0.2} />
<T.AmbientLight intensity={0.5} />
