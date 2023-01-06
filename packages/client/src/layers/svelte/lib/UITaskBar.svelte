<script lang="ts">
  import { player } from "../modules/player";
  import { EntityCategory } from "../modules/entities";
  import UISurvivalCounter from "./UISurvivalCounter.svelte";
  import UISpawn from "./components/UISpawn.svelte";
</script>

<div class="ui-taskbar">
  <div>
    <UISurvivalCounter />
    <!-- {#if $player.entityCategory == EntityCategory.Corpse}
      <UISpawn />
    {:else}
      <UISurvivalCounter />
    {/if} -->
  </div>
</div>

<style>
  .ui-taskbar {
    box-sizing: border-box;
    display: flex;
    justify-content: flex-end;
    align-items: center;
    user-select: none;
    height: var(--taskbar-height);
  }
</style>
