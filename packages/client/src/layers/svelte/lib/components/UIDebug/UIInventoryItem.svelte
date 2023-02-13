<script lang="ts">
  import { addressToColor } from "../../../utils/ui";
  import { network } from "../../../modules/network";

  export let itemId: string;
  export let item: any;
  export let targetBaseEntityId = "";

  let text = "";
  if (item.core) {
    text = "*";
  } else if (item.matter) {
    text = "S";
  } else if (item.abilityMove) {
    text = "M";
  } else if (item.abilityConsume) {
    text = "C";
  } else if (item.abilityExtract) {
    text = "E";
  } else if (item.abilityPlay) {
    text = "P";
  } else if (item.abilityBurn) {
    text = "B";
  } else if (item.untraversable) {
    text = "X";
  }

  function drop() {
    $network.api.drop(itemId);
  }

  function consume() {
    $network.api.burn(itemId);
    // $network.api.consume(itemId);
  }

  function transfer() {
    $network.api.transfer(itemId, targetBaseEntityId);
  }
</script>

<!-- svelte-ignore a11y-click-events-have-key-events -->
<div
  style={"background:" + addressToColor(itemId) + ";"}
  class="inventory-item"
  on:click={() => {
    if (targetBaseEntityId) {
      transfer();
    } else {
      if (item.matter) {
        consume();
      } else {
        drop();
      }
    }
  }}
>
  <div>
    {#if item.matter}{item.matter}{:else}{text}{/if}
  </div>
</div>

<style>
  .inventory-item {
    height: 50px;
    width: 50px;
    overflow: hidden;
    margin-right: 5px;
    margin-bottom: 5px;
    font-size: 22px;
    display: flex;
    justify-content: center;
    align-items: center;
    color: black;
    cursor: pointer;
  }

  .inventory-item:hover {
    opacity: 0.9;
  }
</style>
