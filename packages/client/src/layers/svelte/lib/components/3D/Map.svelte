<script lang="ts">
  import type { GridTile } from "../UIGridMap/index";
  import { initGrid, updateGrid } from "../UIGridMap/index";
  import { textureSources, textures } from "./index";
  import { size } from "lodash";
  import type { Object3D } from "three";
  import { DEG2RAD } from "three/src/math/MathUtils";
  import { T, TransformableObject, useTexture } from "@threlte/core";
  import { player, others } from "../../../modules/player";
  import { blockNumber } from "../../../modules/network";
  import { onMount } from "svelte";
  import { playerPosition } from "../../../modules/sequencer/interpolation";

  /**
   * 3D Objects
   */
  import Base from "./Tiles/Base.svelte";
  import Player from "./Player.svelte";
  import Other from "./Other.svelte";

  /**
   * Setup
   */
  let w: number = 0;
  let h: number = 0;
  let UNIT: number = 5;

  const INITIAL_ROTATION = DEG2RAD * 0;
  const ZOOM_LEVELS = [1500, 1200, 900, 700, 320, 240, 180, 110, 20];

  let grid: GridTile[] = [];
  let rotation = INITIAL_ROTATION;
  let unit = 49;
  let zoomIndex = 6;
  let zoom = ZOOM_LEVELS[zoomIndex];
  let ready = false;
  let loaded = false;
  let texturesLoaded = 0;
  let offsetY = 1;
  let playerComponent: Object3D;

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
    if ($player && $player.position) {
      grid = await updateGrid(grid);
      ready = true;
    }
  });

  function handleZoom(e) {
    if (Number(e.key) > 0 && Number(e.key) < ZOOM_LEVELS.length) {
      zoomIndex = Number(e.key);
    }
    if (e.key === "-") {
      zoomIndex++;
      // UNIT--;
    }
    if (e.key === "=") {
      zoomIndex--;
      // UNIT++;
    }
  }

  $: zoom = ZOOM_LEVELS[zoomIndex];

  /**
   * Init
   */
  onMount(async () => {
    grid = await initGrid(unit);

    if ($player && $player.position) {
      grid = await updateGrid(grid);

      ready = true;
    }
  });

  const onMouseMove = (e) => {
    // const offsetX = e.clientX / w + 0.5;
    // offsetY = e.clientY / h + 0.5;
    // rotation = INITIAL_ROTATION * offsetX;
  };

  const withinScope = (tile: GridTile) =>
    tile.transformation.x > -UNIT &&
    tile.transformation.x < UNIT &&
    tile.transformation.y > -UNIT &&
    tile.transformation.y < UNIT;
</script>

<svelte:window on:keypress={handleZoom} on:mousemove={onMouseMove} bind:innerWidth={w} bind:innerHeight={h} />

<T.Group viewportAware rotation.y={rotation}>
  {#if $player}
    <T.OrthographicCamera
      {zoom}
      near={1}
      far={2000}
      let:ref={cam}
      position.x={$player.position.x}
      position.z={$player.position.y}
      position.y={10}
      makeDefault
    >
      <TransformableObject
        object={cam}
        lookAt={{
          y: 0,
          x: $player.position.x,
          z: $player.position.y,
        }}
      />
    </T.OrthographicCamera>
  {/if}
</T.Group>

<!-- <Compass /> -->

{#if loaded && ready}
  <Player />

  {#each $others as [address, other] (address)}
    <Other {address} {other} />
  {/each}

  <!-- BASE LAYER -->
  <T.Group>
    {#each grid as tile (`${tile.coordinates.x}-${tile.coordinates.y}`)}
      <Base {tile} />
    {/each}
  </T.Group>

  <!-- PLAYER LAYER -->
  <!-- Holds players -->
{/if}

<T.AmbientLight intensity={1} />
