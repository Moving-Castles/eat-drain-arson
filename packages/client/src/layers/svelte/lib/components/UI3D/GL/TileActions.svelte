<script lang="ts">
  import type { GridTile } from "../../UIGridMap";
  import { chebyshev, positionsToTransformation, transformationToDirection } from "../../../../utils/space";
  import { network } from "../../../../modules/network";
  import { entities } from "../../../../modules/entities";
  import { player } from "../../../../modules/player";

  // GL
  import { HTML } from "@threlte/extras";
  import { DEG2RAD } from "three/src/math/MathUtils";
  import { createEventDispatcher } from "svelte";
  const dispatch = createEventDispatcher();

  export let tile: GridTile;

  function move() {
    if (chebyshev($entities[$player.carriedBy].position, tile.coordinates) === 1) {
      $network.api.move(
        transformationToDirection(positionsToTransformation($entities[$player.carriedBy].position, tile.coordinates))
      );
    }
    close();
  }

  function extract() {
    if (chebyshev($entities[$player.carriedBy].position, tile.coordinates) === 1) {
      $network.api.extract(tile.coordinates);
    }
    close();
  }

  function close() {
    dispatch("close", {});
  }

  console.log("tile interactions ");
</script>

<HTML transform scale={0.2} rotation={{ x: DEG2RAD * 180, z: DEG2RAD * 45 }}>
  <div class="tile-interact">
    {#if import.meta.env.DEV}
      <div class="text">x:{tile.coordinates.x},y:{tile.coordinates.y}</div>
    {/if}
    {#if chebyshev($entities[$player.carriedBy].position, tile.coordinates) === 1}
      <div><button on:click={move}>MOVE</button></div>
      <div><button on:click={extract}>EXTRACT</button></div>
    {:else}
      <div class="text">Nothing to do here</div>
    {/if}
    <div><button on:click={close}>CLOSE</button></div>
  </div>
</HTML>

<style>
  .tile-interact {
    padding: 40px;
    border: 3px solid black;
    background: lightgrey;
    color: black;
    font-size: 32px;
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translateX(-50%) translateY(-50%);
  }
</style>
