<script lang="ts">
  import { entities } from "../../../modules/entities";
  import InventoryItem from "./UIInventoryItem.svelte";

  export let baseEntityId: string;
  export let targetBaseEntityId = "";
</script>

<div class="ui-debug-log">
  <div class="inventory">
    {#each Object.entries($entities) as [itemId, item]}
      {#if item.carriedBy === baseEntityId}
        <InventoryItem {itemId} {item} {targetBaseEntityId} />
      {/if}
    {/each}
  </div>
</div>

<style>
  .inventory {
    display: flex;
    flex-wrap: wrap;
  }

  .inventory-item {
    height: 50px;
    width: 50px;
    overflow: hidden;
    margin-right: 5px;
    margin-bottom: 5px;
  }
</style>
