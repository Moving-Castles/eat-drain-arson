<script lang="ts">
  import UISpawn from "./components/UISpawn.svelte";
  import { blockNumber } from "../modules/network";
  import { player, playerEnergy, heartbeats } from "../modules/player";
</script>

<div class="ui-died">
  <div class="">
    <p>
      You survived for {$heartbeats} heartbeats
    </p>
    <UISpawn />
  </div>
</div>

<style>
  .ui-died {
    width: 100%;
    height: 100%;
    display: flex;
    justify-content: center;
    align-items: center;
    backdrop-filter: gray(1);
    -webkit-backdrop-filter: gray(1);
  }
</style>
