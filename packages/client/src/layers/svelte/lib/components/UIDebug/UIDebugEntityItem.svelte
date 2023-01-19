<script lang="ts">
  import type { Entity } from "../../../modules/entities";
  import { entities } from "../../../modules/entities";
  import { playerAddress } from "../../../modules/player";
  import { shortenAddress, addressToColor } from "../../../utils/ui";

  enum EntityType {
    Core,
    BaseEntity,
  }

  export let entityId: string;
  export let entity: Entity;

  const type: EntityType = entity.core ? EntityType.Core : EntityType.BaseEntity;
</script>

<div class="debug-entity-item" class:player={entityId === $playerAddress}>
  <div class="type">{type === EntityType.Core ? "Core" : "Base Entity"}</div>
  <div class="id">
    <span style={"background:" + addressToColor(entityId) + ";"}>
      {shortenAddress(entityId)}
    </span>
  </div>

  {#if type === EntityType.Core}
    <div class="control">Energy: {entity.energy}</div>
    <div class="control">
      Control:
      <span style={"background:" + addressToColor(entity.carriedBy) + ";"}>
        {shortenAddress(entity.carriedBy)}
      </span>
    </div>
    <div class="control">Portable: {entity.portable}</div>
    <div class="control">Creation block: {parseInt(String(entity.creationBlock), 16)}</div>
    <div class="control">Ready block: {parseInt(String(entity.readyBlock), 16)}</div>
  {/if}

  {#if type === EntityType.BaseEntity}
    <div class="position">
      <div class="coord">x:{entity.position?.x}</div>
      <div class="coord">y:{entity.position?.y}</div>
    </div>
    <div class="carrying-capacity">Carrying capacity: {entity.carryingCapacity}</div>
    <div class="inventory">
      <hr />
      <div>Inventory</div>
      <ul>
        {#each Object.entries($entities) as [itemId, item]}
          {#if item.carriedBy === entityId}
            <li class="inventory-item">
              <span style={"background:" + addressToColor(itemId) + ";"}>{shortenAddress(itemId)}</span>
            </li>
          {/if}
        {/each}
      </ul>
    </div>
  {/if}
</div>

<style>
  .debug-entity-item {
    padding: 10px;
    background: lightgrey;
    border-radius: 5px;
    color: black;
    margin-bottom: 5px;
  }

  .type {
    text-decoration: underline;
  }
</style>
