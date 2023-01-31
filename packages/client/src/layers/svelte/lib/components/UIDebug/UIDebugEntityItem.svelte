<script lang="ts">
  import type { Entity } from "../../../modules/entities";
  import { entities, baseEntities } from "../../../modules/entities";
  import { playerAddress, playerCore } from "../../../modules/player";
  import { shortenAddress, addressToColor } from "../../../utils/ui";
  import { EntityType } from "./types";
  import { network } from "../../../modules/network";

  export let entityId: string;
  export let entity: Entity;
  export let type: EntityType;

  let targetEntityId = "";

  function pickUp() {
    $network.api.pickUp(entityId);
  }

  function drop() {
    $network.api.drop(entityId);
  }

  function take() {
    $network.api.take(entityId);
  }

  function give() {
    $network.api.give(entityId, targetEntityId);
  }

  function consume() {
    $network.api.consume(entityId);
  }
</script>

<div class="debug-entity-item" class:player={entityId === $playerAddress}>
  <div class="id">
    <span style={"background:" + addressToColor(entityId) + ";"}>
      {shortenAddress(entityId)}
    </span>
  </div>

  <!-- CORE -->
  {#if type === EntityType.Core}
    <div class="type">CORE</div>
    <div class="control">Energy: {entity.energy}</div>
    <div class="control">
      Carried by:
      <span style={"background:" + addressToColor(entity.carriedBy) + ";"}>
        {shortenAddress(entity.carriedBy)}
        {entityId === $playerAddress ? " (* YOU)" : ""}
      </span>
    </div>
    <div class="control">Portable: {entity.portable}</div>
    <div class="control">Creation block: {parseInt(String(entity.creationBlock), 16)}</div>
    <div class="control">Ready block: {parseInt(String(entity.readyBlock), 16)}</div>
    <hr />
    <button on:click={pickUp}>Pick up</button>
    <button on:click={drop}>Drop</button>
    <button on:click={take}>Take</button>
    <button on:click={give}>Give</button>
    <select bind:value={targetEntityId} name="target" id="target">
      {#each Object.keys($baseEntities) as key}
        <option value={key}>{shortenAddress(key)}</option>
      {/each}
    </select>
  {/if}

  <!-- BASE ENTITY -->
  {#if type === EntityType.BaseEntity}
    <div class="type">BASE</div>
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

  <!-- RESOURCE -->
  {#if type === EntityType.Resource}
    <div class="type">RESOURCE</div>
    <div class="position">
      <div class="coord">x:{entity.position?.x}</div>
      <div class="coord">y:{entity.position?.y}</div>
    </div>
    <div class="matter">Matter: {entity.matter}</div>
  {/if}

  <!-- ITEM -->
  {#if type === EntityType.Item}
    <div class="type">ITEM</div>
    {#if entity.position}
      <div class="position">
        <div class="coord">x:{entity.position?.x}</div>
        <div class="coord">y:{entity.position?.y}</div>
      </div>
    {/if}
    <div class="control">Portable: {entity.portable}</div>

    {#if entity.untraversable}
      <div class="matter">Untraversable: {entity.untraversable}</div>
    {/if}
    {#if entity.abilityMove}
      <div class="matter">AbilityMove: {entity.abilityMove}</div>
    {/if}
    {#if entity.abilityConsume}
      <div class="matter">AbilityConsume: {entity.abilityConsume}</div>
    {/if}
    {#if entity.abilityExtract}
      <div class="matter">AbilityExtract: {entity.abilityExtract}</div>
    {/if}
    {#if entity.carriedBy}
      <div class="control">
        Carried by:
        <span style={"background:" + addressToColor(entity.carriedBy) + ";"}>
          {shortenAddress(entity.carriedBy)}
        </span>
      </div>
    {/if}

    {#if !entity.carriedBy}
      <button on:click={pickUp}>Pick up</button>
    {/if}
    {#if entity.carriedBy === $playerCore.carriedBy}
      <button on:click={drop}>Drop</button>
      <button on:click={give}>Give</button>
      <select bind:value={targetEntityId} name="target" id="target">
        {#each Object.keys($baseEntities) as key}
          <option value={key}>{shortenAddress(key)}</option>
        {/each}
      </select>
    {/if}
    <button on:click={take}>Take</button>
  {/if}

  <!-- SUBSTANCE BLOCK -->
  {#if type === EntityType.SubstanceBlock}
    <div class="type">SUBSTANCE</div>
    {#if entity.position}
      <div class="position">
        <div class="coord">x:{entity.position?.x}</div>
        <div class="coord">y:{entity.position?.y}</div>
      </div>
    {/if}
    <div class="control">Portable: {entity.portable}</div>
    <div class="matter">Matter: {entity.matter}</div>
    {#if entity.carriedBy}
      <div class="control">
        Carried by:
        <span style={"background:" + addressToColor(entity.carriedBy) + ";"}>
          {shortenAddress(entity.carriedBy)}
        </span>
      </div>
    {/if}
    {#if !entity.carriedBy}
      <button on:click={pickUp}>Pick up</button>
    {/if}
    {#if entity.carriedBy === $playerCore.carriedBy}
      <button on:click={consume}>Consume</button>
      <button on:click={drop}>Drop</button>
      <button on:click={take}>Take</button>
      <button on:click={give}>Give</button>
      <select bind:value={targetEntityId} name="target" id="target">
        {#each Object.keys($baseEntities) as key}
          <option value={key}>{shortenAddress(key)}</option>
        {/each}
      </select>
    {/if}
  {/if}

  <!-- UNTRAVERSABLE -->
  {#if type === EntityType.Untraversable}
    <div class="type">UNTRAVERSABLE</div>
    <div class="position">
      <div class="coord">x:{entity.position?.x}</div>
      <div class="coord">y:{entity.position?.y}</div>
    </div>
    <div class="matter">Untraversable: {entity.untraversable}</div>
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
