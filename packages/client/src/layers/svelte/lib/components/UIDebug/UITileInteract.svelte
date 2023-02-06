<script lang="ts">
  import type { Coord } from "@latticexyz/utils";
  import { chebyshev } from "../../../utils/space";
  import { network } from "../../../modules/network";
  import { entities } from "../../../modules/entities";
  import { player } from "../../../modules/player";

  export let selectedTileCoords: Coord;

  import { createEventDispatcher } from "svelte";
  const dispatch = createEventDispatcher();

  const isSame = chebyshev($entities[$player.carriedBy].position, selectedTileCoords) === 0;

  const isAdjacent = chebyshev($entities[$player.carriedBy].position, selectedTileCoords) === 1;

  function move() {
    if (isAdjacent) {
      $network.api.move(selectedTileCoords);
    }
    close();
  }

  function extract() {
    if (isSame || isAdjacent) {
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
  {#if isAdjacent}
    <div><button on:click={move}>MOVE</button></div>
  {/if}
  {#if isSame || isAdjacent}
    <div><button on:click={extract}>EXTRACT</button></div>
  {/if}
  <div><button on:click={close}>CLOSE</button></div>
</div>

<style>
  .tile-interact {
    z-index: 1000000;
    padding: 40px;
    border: 3px solid black;
    background: lightgrey;
    color: black;
    font-size: 32px;
    position: fixed;
    top: 50%;
    left: 50%;
    transform: translateX(-50%) translateY(-50%);
  }
</style>
