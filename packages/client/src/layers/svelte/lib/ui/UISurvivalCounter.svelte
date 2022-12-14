<script lang="ts">
  import { blockNumber } from "../../stores/network";
  import { player, playerEnergy } from "../../stores/player";

  const BLOCKS_IN_DAY = 600;

  let clockTime: number;

  $: clockTime = Math.floor(($blockNumber - $player.birth) / BLOCKS_IN_DAY);
</script>

<div class="ui-clock">
  {#key clockTime}
    <div>block: {$blockNumber} / death: {parseInt(String($player.death))} / energy: {$playerEnergy}</div>
    <!-- <div class="clock-time">You survived {clockTime} days</div> -->
  {/key}
</div>

<style>
  .ui-clock {
    border: 1px solid white;
    padding: var(--padding-button);
  }
</style>
