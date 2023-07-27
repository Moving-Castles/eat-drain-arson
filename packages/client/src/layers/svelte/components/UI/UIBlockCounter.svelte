<script lang="ts">
  import { blockNumber } from "../../modules/network";
</script>

<div class="ui-clock">
  <div>
    block: <span class="ch-4">{$blockNumber}</span>
  </div>
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
