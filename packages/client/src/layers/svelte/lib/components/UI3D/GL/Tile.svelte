<script lang="ts">
  import type { GridTile } from "../../UIGridMap";
  import { Mesh, useTexture } from "@threlte/core";
  import { DEG2RAD } from "three/src/math/MathUtils";
  import { Vector2, Vector3, DoubleSide, MeshBasicMaterial, PlaneGeometry, Color } from "three";
  import TileActions from "./TileActions.svelte";
  import { spring } from "svelte/motion";

  export let tile: GridTile;

  const map = useTexture("/images/tilesets/Tileset_13_Masked.png");
  const opacity = spring(1, { stiffness: 0.2, damping: 0.9 });

  map.repeat = new Vector2(0.1, 0.1);
  map.offset = new Vector2(tile.coordinates.x / 10, tile.coordinates.y / 10);

  let showActions = false;

  let y = 0;
  let {
    x,
    y: z, // y becomes z in 3D space
  } = tile.coordinates;

  const rotation = new Vector3(DEG2RAD * 90, 0, 0);

  const toggleActions = () => {
    showActions = !showActions;
  };

  const previewActions = () => {
    opacity.set(0.8);
  };

  const hideActions = () => {
    opacity.set(1);
  };
</script>

<Mesh
  {rotation}
  userData={{ tile }}
  position={{ x, y, z }}
  interactive
  on:click={toggleActions}
  on:pointerenter={previewActions}
  on:pointerleave={hideActions}
  receiveShadow
  material={new MeshBasicMaterial({
    map,
    wireframe: false,
    side: DoubleSide,
    transparent: true,
    opacity: $opacity,
  })}
  geometry={new PlaneGeometry(1, 1)}
>
  {#if showActions}
    <TileActions on:close={toggleActions} {tile} />
  {/if}
</Mesh>
