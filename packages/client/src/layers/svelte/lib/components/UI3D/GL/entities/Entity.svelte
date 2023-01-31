<script lang="ts">
  import type { Entity } from "../../../../../modules/entities";
  import { getCores } from "../../../../../modules/entities";
  //
  import BaseEntity from "./BaseEntity.svelte";
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

  console.log(id, entity);
</script>

<!-- Entry point and event bus component for all 3D entities -->

<!-- BASE ENTITIES -->
{#if entity.carryingCapacity}
  <BaseEntity on:click={onClick} on:pointerenter={onPointerEnter} on:pointerleave={onPointerLeave} {id} {entity}>
    {#each getCores(id) as [coreId, coreEntity] (coreId)}
      <Core id={coreId} entity={coreEntity} />
    {/each}
  </BaseEntity>
{/if}
