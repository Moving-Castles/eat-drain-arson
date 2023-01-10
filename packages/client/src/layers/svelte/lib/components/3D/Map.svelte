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
  import Compass from "./Compass.svelte";
  import Particles from "./Particles.svelte";

  let w: number = 0;
  let h: number = 0;

  const INITIAL_ROTATION = DEG2RAD * 45;

  let grid: GridTile[] = [];
  let rotation = INITIAL_ROTATION;
  let unit = 49;
  let zoom = 1500;
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
    if (e.key === "-" && zoom > 110) {
      zoom -= 10;
    }
    if (e.key === "=" && zoom < 1500) {
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

      ready = true;
    }
  });

  $: console.log(zoom);

  const onMouseMove = (e) => {
    const offsetX = e.clientX / w + 0.5;
    offsetY = e.clientY / h + 0.5;

    rotation = INITIAL_ROTATION * offsetX;
  };
</script>

<svelte:window on:keypress={handleZoom} on:mousemove={onMouseMove} bind:innerWidth={w} bind:innerHeight={h} />

<T.Group viewportAware rotation.y={rotation}>
  <T.OrthographicCamera
    {zoom}
    near={10}
    far={20}
    let:ref={cam}
    position.x={0}
    position.y={y}
    position.z={10}
    makeDefault
  >
    <TransformableObject object={cam} lookAt={{ y: 0.12 }} />
  </T.OrthographicCamera>
</T.Group>

<!-- <Compass /> -->

{#if loaded && ready}
  <Player />

  <T.Group>
    {#each grid as tile (`${tile.transformation.x}-${tile.transformation.y}`)}
      <Tile {tile} />
    {/each}
  </T.Group>
{/if}

<!-- <T.SpotLight
  position.x={0}
  position.y={5}
  position.z={0}
  intensity={0.3}
  angle={0.9}
  penumbra={0.3}
  lookAt={{ x: 0, y: 0, z: 0 }}
  castShadow
/> -->
<!-- <T.DirectionalLight position.x={x} position.y={y} position.z={z} intensity={1} look castShadow /> -->
<T.AmbientLight intensity={0.5} />
