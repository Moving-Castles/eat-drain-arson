<script lang="ts">
  import { player } from "../../../modules/player";
  import { Canvas } from "@threlte/core";
  import Map from "./GL/Map.svelte";
  import Stats from "./GUI/Stats.svelte";
</script>

<div class="ui-3d-map">
  <Canvas>
    {#if $player}
      <Map />
    {/if}

    <!-- {#if import.meta.env.DEV} -->
    <Stats />
    <!-- {/if} -->
  </Canvas>
</div>

<style>
  .ui-3d-map {
    height: 100%;
  }
  .ui-grid-map {
    height: 100%;
    display: flex;
    flex-wrap: column;
    justify-content: center;
    align-items: center;
  }

  .grid-container {
    aspect-ratio: 1 / 1;
    width: 100%;
    height: 100%;
    max-width: 100%;
    max-height: 100%;
  }

  .grid-container {
    position: relative;
    display: grid;
    grid-template-columns: repeat(var(--cols), minmax(0, 1fr));
    grid-template-rows: repeat(var(--rows), minmax(0, 1fr));
    height: 100%;
  }
</style>
