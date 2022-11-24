<script lang="ts">
  import { fade } from "svelte/transition";
  import { entities } from "../stores/entities";
  import { playerAddress } from "../stores/player";
  import UIComponent from "./UIComponent.svelte";
  import UISpawn from "./UISpawn.svelte";
  import UITextLog from "./UITextLog.svelte";
  import UIAvatar from "./UIAvatar.svelte";
  import UIVisualOperationsEditor from "./UIVisualOperationsEditor.svelte";
  import UIMap from "./UIMap.svelte";
  import UIGridMap from "./UIGridMap.svelte";
  import UIDebugLog from "./UIDebugLog.svelte";
  import Menu from "./Menu.svelte";
  import Clock from "./Clock.svelte";
  import Character from "./Character.svelte";
  // import UIView from "./UIView.svelte";
  // import UIOperationsEditor from "./UIOperationsEditor.svelte";
  // import UIWorldStats from "./UIWorldStats.svelte";
  // import UICharacterStats from "./UICharacterStats.svelte";

  let show = true;
</script>

<div class="dust">
  <img src="/images/dust.png" />
</div>

<div class="menu">
  <Menu />
</div>

<div class="clock">
  <Clock />
</div>

<div class="character">
  <Character />
</div>

{#if show}
  <div
    class="overlay"
    transition:fade
    on:click={() => {
      show = false;
    }}
  >
    Nulla quis lorem ut libero malesuada feugiat. Nulla quis lorem ut libero malesuada feugiat. Nulla quis lorem ut
    libero malesuada feugiat. Pellentesque in ipsum id orci porta dapibus. Curabitur aliquet quam id dui posuere
    blandit.
  </div>
{/if}

{#if show}
  <div
    class="overlay2"
    transition:fade
    on:click={() => {
      show = false;
    }}
  >
    Curabitur non nulla sit amet nisl tempus convallis quis ac lectus. Vivamus magna justo, lacinia eget consectetur
    sed, convallis at tellus. Vivamus suscipit tortor eget felis porttitor volutpat. Cras ultricies ligula sed magna
    dictum porta. Cras ultricies ligula sed magna dictum porta. Donec rutrum congue leo eget malesuada. Pellentesque in
    ipsum id orci porta dapibus. Curabitur non nulla sit amet nisl tempus convallis quis ac lectus. Quisque velit nisi,
    pretium ut lacinia in, elementum id enim. Mauris blandit aliquet elit, eget tincidunt nibh pulvinar a. Curabitur
    aliquet quam id dui posuere blandit. Pellentesque in ipsum id orci porta dapibus. Quisque velit nisi, pretium ut
    lacinia in, elementum id enim. Vivamus suscipit tortor eget felis porttitor volutpat. Vestibulum ante ipsum primis
    in faucibus orci luctus et ultrices posuere cubilia Curae; Donec velit neque, auctor sit amet aliquam vel,
    ullamcorper sit amet ligula. Vivamus suscipit tortor eget felis porttitor volutpat. Donec sollicitudin molestie
    malesuada. Vestibulum ac diam sit amet quam vehicula elementum sed sit amet dui. Proin eget tortor risus. Vivamus
    suscipit tortor eget felis porttitor volutpat.
  </div>
{/if}

<style>
  .dust {
    position: fixed;
    top: 0;
    left: 0;
    width: 100vw;
    height: 100vh;
    z-index: 10000;
    pointer-events: none;
  }

  .dust img {
    width: 100%;
    height: 100%;
    object-fit: cover;
  }

  .menu {
    position: fixed;
    top: 10px;
    left: 10px;
    z-index: 1000;
  }

  .clock {
    position: fixed;
    top: 10px;
    right: 10px;
    z-index: 1000;
  }

  .character {
    position: fixed;
    top: 50%;
    left: 50%;
    transform: translateX(-50%) translateY(-50%);
    z-index: 100;
  }

  .overlay {
    background: rgba(0, 0, 0, 0.5);
    backdrop-filter: blur(5px);
    border: 1px solid white;
    padding: 10px;
    color: white;
    font-size: 14px;

    position: fixed;
    width: 300px;
    height: 400px;
    top: 40%;
    left: 40%;
    transform: translateX(-50%) translateY(-50%);
    z-index: 1000;
  }

  .overlay2 {
    background: rgba(0, 0, 0, 0.5);
    backdrop-filter: blur(5px);
    border: 1px solid white;
    padding: 10px;
    color: white;
    font-size: 14px;
    position: fixed;
    width: 400px;
    height: 600px;
    top: 80px;
    left: 10px;
    z-index: 1000;
  }

  .ui-container {
    position: fixed;
    left: 0;
    top: 0;
    width: 100vw;
    height: 100vh;
    background: black;
  }

  .ui-container-inner {
    position: relative;
    width: 100%;
    height: 100%;
  }
</style>
