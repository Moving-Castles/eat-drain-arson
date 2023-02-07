<script lang="ts">
  import { chebyshev } from "../../../utils/space";
  import { items, baseEntities } from "../../../modules/entities";
  import { playerCore } from "../../../modules/player";
  import { addressToColor } from "../../../utils/ui";

  import Item from "./Item.svelte";
  import Transfer from "./UITransfer.svelte";

  export let baseEntityId: string;
  export let baseEntity: any;

  let transferActive = false;

  const isPlayer = baseEntityId === $playerCore.carriedBy;

  let isSame = false;
  let isAdjacent = false;
  $: isSame = $playerCore.carriedBy
    ? chebyshev($baseEntities[$playerCore.carriedBy].position, baseEntity.position) === 0
    : false;
  $: isAdjacent = $playerCore.carriedBy
    ? chebyshev($baseEntities[$playerCore.carriedBy].position, baseEntity.position) === 1
    : false;

  let untraversable = false;
  $: untraversable = Object.values($items).some((i) => i.carriedBy === baseEntityId && i.untraversable);
</script>

{#if transferActive}
  <Transfer
    {baseEntityId}
    on:close={() => {
      transferActive = false;
    }}
  />
{/if}

<!-- svelte-ignore a11y-click-events-have-key-events -->
<div
  class="base-entity"
  class:untraversable
  style={"background:" + addressToColor(baseEntityId) + ";"}
  class:player={isPlayer}
  on:click={() => {
    if (!isPlayer && (isSame || isAdjacent)) {
      transferActive = true;
    }
  }}
>
  <!-- ITEMS -->
  <div class="inventory">
    {#each Object.entries($items) as [entityId, entity] (entityId)}
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
    cursor: pointer;
    width: fit-content;
    padding: 10px;
  }

  .inventory {
    display: inline-flex;
    justify-content: center;
    align-items: center;
    max-width: 100px;
    flex-wrap: wrap;
    line-height: 0;
  }

  .untraversable {
    width: 100%;
    height: 100%;
    border-radius: 0;
  }

  .player {
    border: 4px dashed white;
    box-sizing: border-box;
  }
</style>
