<script lang="ts">
  import { playerAddress } from "../../../modules/player";
  import { Canvas } from "@threlte/core";
  import { fade } from "svelte/transition";
  import Map from "./GL/Map.svelte";
  import Stats from "./GUI/Stats.svelte";

  let loading = true;
  const onLoad = () => (loading = false);
</script>

<div class="ui-3d-map">
  {#if loading}
    <div transition:fade class="loading">
      <span> Starting... </span>
    </div>
  {/if}

  <!--  -->
  <Canvas>
    {#if $playerAddress}
      <Map on:load={onLoad} />
    {/if}

    {#if import.meta.env.DEV}
      <Stats />
    {/if}
  </Canvas>
</div>

<style>
  .loading {
    position: absolute;
    top: 0;
    right: 0;
    bottom: 0;
    left: 0;
    display: flex;
    flex-flow: column nowrap;
    justify-content: center;
    align-items: center;
    background: rgba(255, 0, 0, 0);
    color: var(--foreground);
  }
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
