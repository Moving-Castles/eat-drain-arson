<script lang="ts">
  import UISpawn from "./components/UISpawn.svelte";
  import { blockNumber } from "../modules/network";
  import { heartbeats } from "../modules/player";
</script>

<div class="ui-died">
  <div class="">
    <p class="inner">
      You died
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
    text-align: center;
  }
</style>
