<script lang="ts">
  import type { Entity } from "../../../modules/entities";
  import { playerAddress } from "../../../modules/player";
  import { shortenAddress, addressToColor } from "../../../utils/ui";

  enum EntityType {
    Core,
    BaseEntity,
  }

  export let address: string;
  export let value: Entity;

  const type: EntityType = value.control ? EntityType.Core : EntityType.BaseEntity;
</script>

<div class="debug-entity-item" class:player={address === $playerAddress}>
  <div class="type">{type === EntityType.Core ? "Core" : "Base Entity"}</div>
  <div class="id">
    <span style={"background:" + addressToColor(address) + ";"}>
      {shortenAddress(address)}
    </span>
  </div>

  {#if type === EntityType.Core}
    <div class="control">Energy: {value.energy}</div>
    <div class="control">
      Control:
      <span style={"background:" + addressToColor(value.control) + ";"}>
        {shortenAddress(value.control)}
      </span>
    </div>
    <div class="control">Portable: {value.portable}</div>
    <div class="control">Creation block: {parseInt(String(value.creationBlock), 16)}</div>
    <div class="control">Ready block: {parseInt(String(value.readyBlock), 16)}</div>
  {/if}

  {#if type === EntityType.BaseEntity}
    <div class="position">
      <div class="coord">x:{value.position?.x}</div>
      <div class="coord">y:{value.position?.y}</div>
    </div>
    <div class="carrying-capacity">Carrying capacity: {value.carryingCapacity}</div>
    <div class="inventory">
      <hr />
      <div>Inventory ({value.inventory.length}/{value.carryingCapacity})</div>
      <ul>
        {#each value.inventory as item}
          <li class="inventory-item">
            <span style={"background:" + addressToColor(item) + ";"}>{shortenAddress(item)}</span>
          </li>
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
