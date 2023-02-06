<script lang="ts">
  import { items } from "../../../modules/entities";
  import { playerCore } from "../../../modules/player";
  import { addressToColor } from "../../../utils/ui";

  import Item from "./Item.svelte";

  let untraversable = false;
  $: untraversable = Object.values($items).some((i) => i.carriedBy === baseEntityId && i.untraversable);

  export let baseEntityId: string;
  export let baseEntity: any;
</script>

<div
  class="base-entity"
  class:untraversable
  style={"background:" + addressToColor(baseEntityId) + ";"}
  class:player={baseEntityId === $playerCore.carriedBy}
>
  <!-- ITEMS -->
  <div class="inventory">
    {#each Object.entries($items) as [entityId, entity]}
      {#if entity.carriedBy == baseEntityId}
        <Item {entityId} {entity} />
      {/if}
    {/each}
  </div>
</div>

<style>
  .base-entity {
    aspect-ratio: 1;
    border-radius: 100%;
    display: flex;
    justify-content: center;
    align-items: center;
    margin: 5px;
    line-height: 0;
  }

  .inventory {
    padding: 10px;
    display: inline-flex;
    justify-content: center;
    align-items: center;
    max-width: 100px;
    flex-wrap: wrap;
    line-height: 0;
  }

  .untraversable {
    width: 280px;
    height: 280px;
    border-radius: 0;
    cursor: not-allowed;
  }

  .player {
    border: 4px dashed white;
    box-sizing: border-box;
  }
</style>
