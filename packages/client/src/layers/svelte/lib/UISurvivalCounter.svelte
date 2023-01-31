<script lang="ts">
  import { blockNumber } from "../modules/network";

  const BLOCKS_IN_DAY = 600;

  let clockTime: number;
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
