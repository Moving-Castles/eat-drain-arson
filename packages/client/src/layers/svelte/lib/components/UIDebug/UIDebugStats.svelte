<script lang="ts">
  import { entities } from "../../../modules/entities";
  import { playerCore, playerBaseEntity, playerAddress } from "../../../modules/player";
  import { shortenAddress, addressToColor } from "../../../utils/ui";
  import Inventory from "./UIInventory.svelte";

  $: console.log($entities);
</script>

<div class="ui-debug-log">
  {#if $playerCore}
    <div class="control">
      <span style={"color:" + addressToColor($playerAddress) + ";"}>
        CORE: {shortenAddress($playerAddress)}
      </span>
    </div>
    <div class="control">Energy: {$playerCore.energy}</div>
    <div class="control">Creation block: {parseInt(String($playerCore.creationBlock), 16)}</div>
    <div class="control">Ready block: {parseInt(String($playerCore.readyBlock), 16)}</div>
    <hr />
    {#if $playerBaseEntity && $playerBaseEntity.position}
      <div class="control">
        <span style={"color:" + addressToColor($playerCore.carriedBy) + ";"}>
          BASE: {shortenAddress($playerCore.carriedBy)}
        </span>
      </div>
      <div class="position">
        <div class="coord">x:{$playerBaseEntity.position.x}</div>
        <div class="coord">y:{$playerBaseEntity.position.y}</div>
      </div>
      <hr />
    {:else}
      YOU ARE IN THE VOID
    {/if}
    {#if $playerCore.carriedBy}
      <Inventory baseEntityId={$playerCore.carriedBy} />
    {/if}
  {/if}
</div>
