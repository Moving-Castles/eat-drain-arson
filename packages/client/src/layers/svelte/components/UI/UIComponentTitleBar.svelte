<script lang="ts">
  import { playSound } from "../../../howler";
  import { uiState } from "./index";
  import type { UIComponentOptions } from "./config";
  export let id: string;
  export let title = "";
  export let options: UIComponentOptions;
</script>

<div class="titlebar border">
  {title}

  <div>
    {#if options?.muted}
      <button class="close" on:click={() => uiState.toggle(id, "muted")}>
        {!options.muted ? "[mut]" : "[unm]"}
      </button>
    {/if}

    {#if !options?.persistent}
      <button
        class="close"
        on:click={() => {
          playSound("error", "ui");
          uiState.close(id);
        }}
      >
        [×]
      </button>
    {/if}
  </div>
</div>

<style>
  .titlebar {
    width: 100%;
    padding: var(--padding-button);
    font-size: var(--font-size);
    color: var(--foreground);
    background-color: var(--background);
    height: var(--titlebar-height);
    font-weight: bold;
    display: flex;
    flex-flow: row nowrap;
    justify-content: space-between;
    /* -webkit-backdrop-filter: var(--backdrop); */
    z-index: 99;
  }

  .titlebar.border {
    border-bottom: 1px solid var(--foreground);
  }

  .close {
    all: unset;
    cursor: pointer;
  }
</style>
