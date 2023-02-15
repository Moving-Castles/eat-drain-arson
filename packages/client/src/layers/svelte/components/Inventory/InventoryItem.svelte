<script lang="ts">
  import { onMount, onDestroy } from "svelte";
  import tippy from "tippy.js";
  import "tippy.js/dist/tippy.css"; // optional for styling
  import { addressToColor } from "../../utils/ui";
  import { network, blockNumber } from "../../modules/network";
  import { playerAddress, playerAbilities, playerCore } from "../../modules/player";
  import type { Entity } from "../../modules/entities";
  import { Activity } from "../../modules/entities";

  export let itemId: string;
  export let item: Entity;
  export let targetBaseEntityId: string;

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

  function drop() {
    $network.api.drop(itemId);
  }

  function consume() {
    $network.api.consume(itemId);
  }

  function burn() {
    $network.api.burn(itemId);
  }

  function play() {
    $network.api.play();
  }

  onMount(async () => {
    if (!targetBaseEntityId) {
      toolTip = tippy(markerEl, {
        content: dialogEl,
        interactive: true,
      });
    }
  });

  onDestroy(() => {
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
  style={"background:" + addressToColor(itemId) + ";"}
  on:click={() => {
    if (targetBaseEntityId) {
      $network.api.transfer(itemId, targetBaseEntityId);
    }
  }}
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

{#if !targetBaseEntityId}
  <div class="dialog" bind:this={dialogEl}>
    <div class="description">{info.description}</div>

    {#if item.burnBlock}
      {#if item.burnBlock > $blockNumber}
        <div class="description">BURNING🔥🔥🔥</div>
      {:else}
        <div class="description">ASHES</div>
      {/if}
    {/if}

    {#if item.abilityPlay}
      <button on:click={play}>{$playerCore.commit === Activity.Play ? "STOP" : "play"}</button>
    {/if}

    {#if item.matter}
      {#if !item.burnBlock}
        {#if $playerAbilities.includes("abilityBurn")}
          <button on:click={burn}>burn</button>
        {/if}
        {#if $playerAbilities.includes("abilityConsume")}
          <button on:click={consume}>consume</button>
        {/if}
      {/if}
    {/if}

    <button on:click={drop}>drop</button>
  </div>
{/if}

<style>
  .item {
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

  .item:hover {
    opacity: 0.9;
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
