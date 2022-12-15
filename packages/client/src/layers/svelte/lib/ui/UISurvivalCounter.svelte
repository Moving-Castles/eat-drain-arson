<script lang="ts">
  import { blockNumber } from "../../stores/network";
  import { player, playerEnergy, heartbeats } from "../../stores/player";

  const BLOCKS_IN_DAY = 600;

  let clockTime: number;

  $: clockTime = Math.floor(($blockNumber - $player.birth) / BLOCKS_IN_DAY);
</script>

<div class="ui-clock">
  {#key clockTime}
    <div>block: <span class="ch-4">{$blockNumber}</span> / death: <span class="ch-4">{parseInt(String($player.death))}</span> / energy: <span class="ch-4">{$playerEnergy}</span></div>
  {/key}

  {$heartbeats}
</div>

<style>
  .ui-clock {
    border: 1px solid white;
    padding: var(--padding-button);
  }

  .ch-4 {
    display: inline-block;
    min-width: 4ch;
  }
</style>
