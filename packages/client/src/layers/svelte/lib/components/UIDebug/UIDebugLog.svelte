<script lang="ts">
  import { cores, baseEntities, resources, substanceBlocks, items, untraversables } from "../../../modules/entities";
  import DebugEntityItem from "./UIDebugEntityItem.svelte";
  import { EntityType } from "./types";
</script>

<div class="ui-debug-log">
  <h1>CORES</h1>
  {#each Object.entries($cores) as [entityId, entity], i (entityId)}
    <DebugEntityItem {entityId} {entity} type={EntityType.Core} />
  {/each}
  <h1>BASE ENTITIES</h1>
  {#each Object.entries($baseEntities) as [entityId, entity], i (entityId)}
    <DebugEntityItem {entityId} {entity} type={EntityType.BaseEntity} />
  {/each}
  <h1>RESOURCES</h1>
  {#each Object.entries($resources) as [entityId, entity], i (entityId)}
    <DebugEntityItem {entityId} {entity} type={EntityType.Resource} />
  {/each}
  <h1>ITEMS</h1>
  {#each Object.entries($items) as [entityId, entity], i (entityId)}
    <DebugEntityItem {entityId} {entity} type={EntityType.Item} />
  {/each}
  <h1>SUBSTANCE BLOCKS</h1>
  {#each Object.entries($substanceBlocks) as [entityId, entity], i (entityId)}
    <DebugEntityItem {entityId} {entity} type={EntityType.SubstanceBlock} />
  {/each}
</div>
