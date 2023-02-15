<script lang="ts">
  import { onMount, onDestroy } from "svelte";
  import tippy from "tippy.js";
  import "tippy.js/dist/tippy.css"; // optional for styling
  import { addressToColor } from "../../utils/ui";
  import type { Entity } from "../../modules/entities";
  import { network, blockNumber } from "../../modules/network";
  import { playerAddress, playerAbilities } from "../../modules/player";

  export let itemId: string;
  export let item: Entity;
  export let free = false;

  let markerEl: HTMLElement;
  let dialogEl: HTMLElement;
  let toolTip: any;

  let info = {
    symbol: "",
    description: "",
  };

  const setInfo = (symbol: string, description: string) => {
    info.symbol = symbol;
    info.description = description;
  };

  if (item.core) {
    setInfo("*", itemId === $playerAddress ? "Core (you)" : "Core: " + item.energy + " energy");
  } else if (item.matter) {
    setInfo("S", "Substance block");
  } else if (item.abilityMove) {
    setInfo("M", "Ability: Move");
  } else if (item.abilityConsume) {
    setInfo("C", "Ability: Consume");
  } else if (item.abilityExtract) {
    setInfo("E", "Ability: Extract");
  } else if (item.abilityPlay) {
    setInfo("P", "Ability: Play");
  } else if (item.abilityBurn) {
    setInfo("B", "Ability: Burn");
  } else if (item.untraversable) {
    setInfo("X", "Untraversable");
  }

  function pickUp() {
    $network.api.pickUp(itemId);
  }

  function burn() {
    $network.api.burn(itemId);
  }

  onMount(async () => {
    // console.log("** mount", itemId);
    if (free) {
      toolTip = tippy(markerEl, {
        content: dialogEl,
        interactive: true,
      });
    }
  });

  onDestroy(() => {
    // console.log("** destroy", itemId);
    if (toolTip) {
      toolTip.destroy();
    }
  });
</script>

<!-- svelte-ignore a11y-click-events-have-key-events -->
<div
  class="item"
  class:burning={item.burnBlock > $blockNumber}
  class:burnt={item.burnBlock <= $blockNumber}
  bind:this={markerEl}
  class:free
  style={item.burnBlock ? "" : "background:" + addressToColor(itemId) + ";"}
>
  {#if item.matter}
    {#if item.burnBlock}
      {#if item.burnBlock > $blockNumber}
        {item.burnBlock - $blockNumber}
      {:else}
        ╳
      {/if}
    {:else}
      {item.matter}
    {/if}
  {:else}
    {info.symbol}
  {/if}
</div>

{#if free}
  <div class="dialog" bind:this={dialogEl}>
    <div class="description">{info.description}</div>

    {#if item.burnBlock}
      {#if item.burnBlock > $blockNumber}
        <div class="description">BURNING🔥🔥🔥</div>
      {:else}
        <div class="description">ASHES</div>
      {/if}
    {/if}

    {#if item.matter && !item.burnBlock && $playerAbilities.includes("abilityBurn")}
      <button on:click={burn}>burn</button>
    {/if}

    <button on:click={pickUp}>pickup</button>
  </div>
{/if}

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

  .dialog {
    padding: 10px;
    text-align: center;
  }

  .description {
    font-weight: bold;
    margin-bottom: 10px;
  }

  /* Define the keyframes */
  @keyframes color-change {
    0% {
      background: red;
    }
    50% {
      background: orangered;
    }
    100% {
      background: red;
    }
  }

  .item.burning {
    animation: color-change 2s ease-in-out infinite;
  }

  .item.burnt {
    background: rgb(34, 34, 34) !important;
  }
</style>
