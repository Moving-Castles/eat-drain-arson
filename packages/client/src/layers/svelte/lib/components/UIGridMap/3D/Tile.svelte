<script lang="ts">
  import { get } from "svelte/store";
  import type { GridTile } from "../UIGridMap/index";
  import { useTexture } from "@threlte/core";
  import { PlaneGeometry, MeshBasicMaterial } from "three";
  import { player } from "../../../modules/player";

  export let tile: GridTile;

  let overlays = [];

  $: overlays = [...conditions.map((c) => c(tile)).filter((o) => !!o)];

  const material = new MeshBasicMaterial();
</script>

<Mesh />

<style>
  .tile-overlay {
    width: 100%;
    height: 100%;
    pointer-events: none;
    background-size: contain;
    background-position: center;
    position: absolute;
  }

  .tile-overlay.empty {
    /* public/images/tiles/overlays/empty.png */
  }

  .tile-overlay.corpse {
    /* public/images/tiles/overlays/corpse.png */
  }

  .tile-overlay.mined-1 {
    /* public/images/tiles/overlays/mined-1.png */
  }

  .tile-overlay.mined-2 {
    /* public/images/tiles/overlays/mined-2.png */
  }

  .tile-overlay.mined-3 {
    /* public/images/tiles/overlays/mined-3.png */
  }

  .tile-overlay.map {
    /* public/images/tiles/overlays/map.png */
    mix-blend-mode: multiply;
  }

  .tile-overlay.mask.corpse {
    filter: grayscale(1);
    /* background-image: url("../../../../../../public/images/masks/0.png"); */
  }
  .tile-overlay.mask.mask-0 {
    background-image: url("../../../../../public/images/masks/0.png");
  }
  .tile-overlay.mask.mask-1 {
    background-image: url("../../../../../public/images/masks/1.png");
  }
  .tile-overlay.mask.mask-2 {
    background-image: url("../../../../../public/images/masks/2.png");
  }
  .tile-overlay.mask.mask-3 {
    background-image: url("../../../../../public/images/masks/3.png");
  }
  .tile-overlay.fire.fire-on {
    background-image: url("../../../../../public/images/fire/on.gif");
  }
  .tile-overlay.fire.fire-off {
    background-image: url("../../../../../public/images/fire/off.png");
  }

  .grid-tile {
    aspect-ratio: 1 / 1;
    max-width: 100%;
    max-height: 100%;
    display: flex;
    justify-content: center;
    align-items: center;
    color: rgba(255, 255, 255, 1);
    font-size: 9px;
    text-align: center;
    position: relative;
    background-size: cover;
    cursor: pointer;
  }

  .text {
    opacity: 0;
  }

  .dust-1 {
    /* public/images/tiles/dust/1.png */
  }

  .dust-2 {
    /* public/images/tiles/dust/2.png */
  }

  .dust-3 {
    /* public/images/tiles/dust/3.png */
  }

  .dust-4 {
    /* public/images/tiles/dust/4.png */
  }

  .debris-1 {
    /* public/images/tiles/debris/1.png */
  }

  .debris-2 {
    /* public/images/tiles/debris/2.png */
  }

  .debris-3 {
    /* public/images/tiles/debris/3.png */
  }

  .debris-4 {
    /* public/images/tiles/debris/4.png */
  }

  .ruins-1 {
    /* public/images/tiles/ruins/1.png */
  }

  .ruins-2 {
    /* public/images/tiles/ruins/2.png */
  }

  .ruins-3 {
    /* public/images/tiles/ruins/3.png */
  }

  .ruins-4 {
    /* public/images/tiles/ruins/4.png */
  }

  .icon {
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translateX(-50%) translateY(-50%);
    font-size: 4vw;
    z-index: 100;
  }

  .self {
    z-index: 1000;
  }
</style>
