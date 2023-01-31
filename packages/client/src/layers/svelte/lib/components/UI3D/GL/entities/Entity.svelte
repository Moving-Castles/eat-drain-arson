<script lang="ts">
  import type { Entity } from "../../../../../modules/entities";
  import { getCores } from "../../../../../modules/entities";
  //
  import BaseEntity from "./BaseEntity.svelte";
  import Core from "./Core.svelte";

  export let id: string;
  export let entity: Entity;

  console.log(id, entity);
</script>

{#if entity.carryingCapacity}
  <BaseEntity {id} {entity}>
    {#each getCores(id) as [coreId, coreEntity] (coreId)}
      <Core id={coreId} entity={coreEntity} />
    {/each}
  </BaseEntity>
{/if}
