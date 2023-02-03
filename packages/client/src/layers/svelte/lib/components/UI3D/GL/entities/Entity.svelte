<script lang="ts">
  import type { Entity } from "../../../../../modules/entities";
  //
  import BaseEntity from "./BaseEntity.svelte";
  import BaseItem from "./BaseItem.svelte";
  import Core from "./Core.svelte";

  export let id: string;
  export let entity: Entity;

  const onClick = ({ detail }) => {
    console.log(detail);
  };

  const onPointerEnter = ({ detail }) => {
    console.log(detail);
  };

  const onPointerLeave = ({ detail }) => {
    console.log(detail);
  };
</script>

<!-- Entry point and event bus component for all 3D entities -->

<!-- BASE ENTITIES -->
{#if entity.carryingCapacity}
  <BaseEntity on:click={onClick} on:pointerenter={onPointerEnter} on:pointerleave={onPointerLeave} {id} {entity} />
{/if}

<!-- ITEM that has not been picked up -->
{#if entity.portable && !entity.carriedBy}
  <BaseItem {id} {entity} />
{/if}
