<script lang="ts">
  import { entities } from "../../../modules/entities";
  import DebugEntityItem from "./UIDebugEntityItem.svelte";

  $: console.log($entities);
</script>

<div class="ui-debug-log">
  {#each Object.entries($entities) as [address, value], i (address)}
    <DebugEntityItem {address} {value} />
  {/each}
</div>
