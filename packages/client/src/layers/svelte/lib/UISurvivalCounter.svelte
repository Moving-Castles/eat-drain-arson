<script lang="ts">
  import { blockNumber } from "../modules/network";
  import { player } from "../modules/player";

  const BLOCKS_IN_DAY = 600;

  let clockTime: number;

  $: console.log($player.energy);
  $: clockTime = Math.floor(($blockNumber - $player.birth) / BLOCKS_IN_DAY);
</script>

<div class="ui-clock">
  {#key clockTime}
    <div>
      block: <span class="ch-4">{$blockNumber}</span>
    </div>
  {/key}
</div>

<style>
  .ui-clock {
    border: 1px solid white;
    background-color: var(--background);
    padding: var(--padding-button);
  }

  .ch-4 {
    display: inline-block;
    min-width: 4ch;
  }
</style>
