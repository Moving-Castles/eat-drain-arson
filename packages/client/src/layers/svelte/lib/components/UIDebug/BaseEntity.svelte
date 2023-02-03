<script lang="ts">
  import { items } from "../../../modules/entities";
  import { playerCore } from "../../../modules/player";
  import { addressToColor } from "../../../utils/ui";

  import Item from "./Item.svelte";

  export let baseEntityId: string;
  export let baseEntity: any;
</script>

<div
  class="base-entity"
  style={"background:" + addressToColor(baseEntityId) + ";"}
  class:player={baseEntityId === $playerCore.carriedBy}
>
  <!-- ITEMS -->
  {#each Object.entries($items) as [entityId, entity]}
    {#if entity.carriedBy == baseEntityId}
      <Item {entityId} {entity} />
    {/if}
  {/each}
</div>

<style>
  .base-entity {
    width: 100px;
    height: 100px;
    border-radius: 100%;
    display: flex;
    justify-content: center;
    align-items: center;
    margin: 5px;
  }

  .player {
    border: 6px dashed white;
    box-sizing: border-box;
  }
</style>
