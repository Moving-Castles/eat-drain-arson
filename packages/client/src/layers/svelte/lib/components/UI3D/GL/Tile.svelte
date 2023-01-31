<script lang="ts">
  import type { GridTile } from "../../UIGridMap";
  import { Mesh, useTexture } from "@threlte/core";
  import { DEG2RAD } from "three/src/math/MathUtils";
  import { Vector2, Vector3, DoubleSide, MeshBasicMaterial, PlaneGeometry, Color } from "three";
  import TileActions from "./TileActions.svelte";
  import { spring } from "svelte/motion";

  export let tile: GridTile;

  // SVELTE
  import { createEventDispatcher } from "svelte";

  const dispatch = createEventDispatcher();

  const map = useTexture("/images/tilesets/Tileset_13_Masked.png", {
    onLoad: () => {
      dispatch("load");
    },
  });
  const opacity = spring(1, { stiffness: 0.2, damping: 0.9 });

  map.repeat = new Vector2(0.1, 0.1);
  map.offset = new Vector2(tile.coordinates.x / 10, tile.coordinates.y / 10);

  let showActions = false;

  let y = 0;
  let {
    x,
    y: z, // y becomes z in 3D space
  } = tile.coordinates;

  const rx = spring(DEG2RAD * 90, { stiffness: 0.2, damping: 0.8 });
  const ry = spring(0, { stiffness: 0.2, damping: 0.8 });
  const rz = spring(0, { stiffness: 0.2, damping: 0.8 });
  const tileY = spring(y, { stiffness: 0.05, damping: 0.2 });

  const toggleActions = () => {
    showActions = !showActions;

    if (showActions) previewActions();
    if (!showActions) hideActions();
  };

  const previewActions = () => {
    opacity.set(0.8);
    // $rx = DEG2RAD * 270;

    // $tileY = 1;
    // rotation.set({ x: 0, y  DEG2RAD * 90, z: 0 });
  };

  const onPointerEnter = () => opacity.set(0.8);
  const onPointerLeave = () => opacity.set(1);

  const hideActions = () => {
    // $rx = DEG2RAD * 90;
    // $ry = 0;
    // $rz = 0;
    // $tileY = 0;
  };
</script>

<Mesh
  rotation={{ x: $rx, y: $ry, z: $rz }}
  userData={{ tile }}
  position={{ x, z }}
  interactive
  on:click={toggleActions}
  on:pointerenter={onPointerEnter}
  on:pointerleave={onPointerLeave}
  receiveShadow
  material={new MeshBasicMaterial({
    map,
    wireframe: false,
    side: DoubleSide,
    transparent: true,
    opacity: $opacity,
  })}
  geometry={new PlaneGeometry(1, 1)}
/>

{#if showActions}
  <TileActions position={{ x, y, z }} on:close={toggleActions} {tile} />
{/if}
