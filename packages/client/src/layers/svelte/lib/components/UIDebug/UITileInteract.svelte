<script lang="ts">
  import type { Coord } from "@latticexyz/utils";
  import { chebyshev, positionsToTransformation, transformationToDirection } from "../../../utils/space";
  import { network } from "../../../modules/network";
  import { entities } from "../../../modules/entities";
  import { player } from "../../../modules/player";

  import { createEventDispatcher } from "svelte";
  const dispatch = createEventDispatcher();

  export let selectedTileCoords: Coord;

  function move() {
    if (chebyshev($entities[$player.carriedBy].position, selectedTileCoords) === 1) {
      $network.api.move(
        transformationToDirection(positionsToTransformation($entities[$player.carriedBy].position, selectedTileCoords))
      );
    }
    close();
  }

  function extract() {
    if (chebyshev($entities[$player.carriedBy].position, selectedTileCoords) === 1) {
      $network.api.extract(selectedTileCoords);
    }
    close();
  }

  function close() {
    dispatch("close", {});
  }
</script>

<div class="tile-interact">
  <div class="text">x:{selectedTileCoords.x},y:{selectedTileCoords.y}</div>
  <div><button on:click={move}>MOVE</button></div>
  <div><button on:click={extract}>EXTRACT</button></div>
  <div><button on:click={close}>CLOSE</button></div>
</div>

<style>
  .tile-interact {
    z-index: 10000;
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
