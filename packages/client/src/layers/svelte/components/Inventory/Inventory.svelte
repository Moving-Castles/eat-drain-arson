<script lang="ts">
  import { entities, baseEntities } from "../../modules/entities";
  import InventoryItem from "./InventoryItem.svelte";

  export let baseEntityId: string;
  export let targetBaseEntityId = "";
</script>

<div class="cc">
  Carrying capacity: {$baseEntities[baseEntityId] ? $baseEntities[baseEntityId].carryingCapacity : 0}
</div>
<div class="inventory">
  {#each Object.entries($entities) as [itemId, item] (itemId)}
    {#if item.carriedBy === baseEntityId}
      <InventoryItem {itemId} {item} {targetBaseEntityId} />
    {/if}
  {/each}
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

  .cc {
    margin-bottom: 5px;
  }
</style>
