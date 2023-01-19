<script lang="ts">
  import { playerAddress } from "../../../modules/player";
  import { shortenAddress } from "../../../utils/ui";

  enum EntityType {
    Core,
    BaseEntity,
  }

  export let address: string;
  export let value: any;

  const type: EntityType = value.control ? EntityType.Core : EntityType.BaseEntity;
</script>

<div class="debug-entity-item" class:player={address === $playerAddress}>
  <div class="type">{type === EntityType.Core ? "Core" : "Base Entity"}</div>
  <div class="id">{shortenAddress(address)}</div>

  {#if type === EntityType.Core}
    <div class="control">Energy: {value.energy}</div>
    <div class="control">Controlling: {shortenAddress(value.control)}</div>
    <div class="control">Portable: {value.portable}</div>
    <div class="control">Creation block: {parseInt(value.creationBlock, 16)}</div>
    <div class="control">Ready block: {parseInt(value.readyBlock, 16)}</div>
  {/if}

  {#if type === EntityType.BaseEntity}
    <div class="position">
      <div class="coord">x:{value.position?.x}</div>
      <div class="coord">y:{value.position?.y}</div>
    </div>
    <div class="inventory">
      <div>Inventory</div>
      {#each value.inventory as item}
        <div class="inventory-item">{shortenAddress(item)}</div>
      {/each}
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
