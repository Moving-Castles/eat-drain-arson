<script lang="ts">
  import { Activity } from "../../modules/entities";
  import { playerCore, playerBaseEntity, playerAddress } from "../../modules/player";
  import { shortenAddress, addressToColor } from "../../utils/ui";
  import Inventory from "../Inventory/Inventory.svelte";
  import { addToSequencer } from "../../modules/actionSequencer";

  function play() {
    addToSequencer("system.Play");
  }
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
      <div class="play">
        {#if $playerCore.commit === Activity.Play}
          <div>...P.l.A.y.I.n.G...</div>
          <div><button on:click={play}>STOP</button></div>
        {/if}
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

<style>
  .play {
    font-size: 24px;
    margin-top: 10px;
    margin-bottom: 10px;
  }
</style>
