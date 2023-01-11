<script lang="ts">
  import type { GridTile } from "../UIGridMap/index";
  import { initGrid, updateGrid } from "../UIGridMap/index";
  import { textureSources, textures } from "./index";
  import { size } from "lodash";
  import { DEG2RAD } from "three/src/math/MathUtils";
  import { T, TransformableObject, useTexture } from "@threlte/core";
  import { player } from "../../../modules/player";
  import { blockNumber } from "../../../modules/network";
  import { onMount, tick } from "svelte";

  /**
   * 3D Objects
   */
  import Base from "./Tiles/Base.svelte";
  import Player from "./Player.svelte";

  let w: number = 0;
  let h: number = 0;
  let UNIT: number = 3;

  const INITIAL_ROTATION = DEG2RAD * 45;
  const ZOOM_LEVELS = [1500, 1200, 900, 700, 320, 240, 180, 110, 40];

  let grid: GridTile[] = [];
  let rotation = INITIAL_ROTATION;
  let unit = 49;
  let zoomIndex = 4;
  let zoom = ZOOM_LEVELS[zoomIndex];
  let ready = false;
  let loaded = false;
  let texturesLoaded = 0;
  let offsetY = 1;

  let x = 0;
  let y = 10 + offsetY / 4;
  let z = 20;

  /**
   * Preload textures
   */
  $textures = useTexture(textureSources, {
    onLoad: (e) => {
      texturesLoaded++;
    },
  });

  $: loaded = texturesLoaded === size(textureSources);
  $: y = 10 + offsetY / 4;

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
    if (Number(e.key) > 0 && Number(e.key) < ZOOM_LEVELS.length) {
      zoomIndex = Number(e.key);
    }
    if (e.key === "-") {
      // zoomIndex++;
      UNIT--;
    }
    if (e.key === "=") {
      // zoomIndex--;
      UNIT++;
    }
  }

  $: zoom = ZOOM_LEVELS[zoomIndex];

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

  const onMouseMove = (e) => {
    const offsetX = e.clientX / w + 0.5;
    offsetY = e.clientY / h + 0.5;

    rotation = INITIAL_ROTATION * offsetX;
  };

  const withinScope = (tile: GridTile) =>
    tile.transformation.x > -UNIT &&
    tile.transformation.x < UNIT &&
    tile.transformation.y > -UNIT &&
    tile.transformation.y < UNIT;
</script>

<svelte:window on:keypress={handleZoom} on:mousemove={onMouseMove} bind:innerWidth={w} bind:innerHeight={h} />

<T.Group viewportAware rotation.y={rotation}>
  <T.OrthographicCamera
    {zoom}
    near={1}
    far={200}
    let:ref={cam}
    position.x={0}
    position.y={y}
    position.z={z}
    makeDefault
  >
    <TransformableObject object={cam} lookAt={{ y: 0 }} />
  </T.OrthographicCamera>
</T.Group>

<!-- <Compass /> -->

{#if loaded && ready}
  <Player />

  {#each Array.from(Array(100).keys()) as i (i)}
    <T.Group position.x={Math.floor(Math.random() * 20) - 10} position.z={Math.floor(Math.random() * 20) - 10}>
      <Player />
    </T.Group>
  {/each}

  <!-- BASE LAYER -->
  <!-- Holds textures -->
  <T.Group>
    {#each grid as tile (`${tile.transformation.x}-${tile.transformation.y}`)}
      {#if withinScope(tile)}
        <Base {tile} />
      {/if}
    {/each}
  </T.Group>

  <!-- PLAYER LAYER -->
  <!-- Holds players -->
{/if}

<T.AmbientLight intensity={1} />
