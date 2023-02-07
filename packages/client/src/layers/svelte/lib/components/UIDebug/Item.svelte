<script lang="ts">
  import { addressToColor } from "../../../utils/ui";
  import { network } from "../../../modules/network";

  export let entityId: string;
  export let entity: any;
  export let free = false;

  let text = "";
  if (entity.core) {
    text = "*";
  } else if (entity.matter) {
    text = "S";
  } else if (entity.abilityMove) {
    text = "M";
  } else if (entity.abilityConsume) {
    text = "C";
  } else if (entity.abilityExtract) {
    text = "E";
  } else if (entity.untraversable) {
    text = "X";
  }

  function pickUp(entityId: string) {
    if (free) {
      $network.api.pickUp(entityId);
    }
  }
</script>

<!-- svelte-ignore a11y-click-events-have-key-events -->
<div
  class="item"
  class:free
  on:click={(e) => {
    e.preventDefault();
    pickUp(entityId);
  }}
  style={"background:" + addressToColor(entityId) + ";"}
>
  <div>
    {#if entity.matter}{entity.matter}{:else}{text}{/if}
  </div>
</div>

<style>
  .item {
    width: 20px;
    height: 20px;
    display: inline-flex;
    justify-content: center;
    align-items: center;
    color: black;
    font-size: 12px;
  }

  .free {
    width: 40px;
    height: 40px;
    display: flex;
    justify-content: center;
    align-items: center;
    color: black;
    cursor: pointer;
    z-index: 10000;
    cursor: grab;
    font-size: 12px;
  }
</style>
