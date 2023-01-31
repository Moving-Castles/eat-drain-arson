<script lang="ts">
  import type { Entity } from "../../../../../modules/entities";
  import BaseEntity from "./BaseEntity.svelte";

  export let id: string;
  export let entity: Entity;

  console.log(id, entity);
</script>

{#if entity.carryingCapacity}
  <BaseEntity {id} {entity} />
{/if}
