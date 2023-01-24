<script lang="ts">
  import UI3DMap from "./components/3D/UI3DMap.svelte";
  // import UI3DMap from "./components/UIGridMap/UIGridMap.svelte";
  import { uiState } from "../modules/ui";
  import { ready } from "../modules/network";
  import { player } from "../modules/player";
  import UITaskBar from "./UITaskBar.svelte";
  import UIComponent from "./UIComponent.svelte";
  import UISpawn from "./components/UISpawn.svelte";
  import UILoading from "./components/UILoading.svelte";
</script>

<!-- The game layer -->
<div class="ui-container no-padding">
  <div class="ui-container-center">
    <UI3DMap />
  </div>
</div>

<!-- The UI layer -->
<div class="ui-container">
  {#if !$player}
    <span />
  {:else}
    <UITaskBar />
  {/if}
  <div class="ui-container-inner">
    {#if !$ready}
      <UIComponent id="ui-loading" options={{ fluid: true, bare: true, span: true }} area="mm">
        <UILoading />
      </UIComponent>
    {:else if !$player}
      <UIComponent id="ui-spawn" options={{ fluid: true, bare: true, span: true }} area="mm">
        <UISpawn />
      </UIComponent>
    {:else}
      {#each Object.values($uiState).filter((i) => !i.options?.center) as { id, active, title, options, grid, component } (id)}
        <UIComponent {id} {active} {title} {options} {grid}>
          <svelte:component this={component} />
        </UIComponent>
      {/each}
    {/if}
  </div>
</div>

<style>
  .ui-container {
    position: fixed;
    left: 0;
    top: 0;
    width: 100vw;
    height: 100vh;
    color: var(--foreground);
    padding: 24px;
    display: grid;
    grid-template-columns: 1fr;
    grid-template-rows: min-content 93%;
    box-sizing: border-box;
    align-items: stretch;
    gap: var(--row-gap);
  }

  .ui-container.no-padding {
    padding: 0;
  }

  .ui-container-center {
    grid-column: 1 / 2;
    grid-row: 1 / span 3;
    z-index: -1;
  }

  .mobile .ui-container-inner {
    position: relative;
    width: 100%;
    height: 100%;
    display: grid;
    grid-column: 1 / 2;
    grid-row: 2 / span 1;
    grid-template-columns: 1fr 1fr 1fr;
    grid-template-rows: repeat(9, minmax(0, 1fr));
    grid-template-areas:
      "tl tm tr"
      "tl tm tr"
      "tl tm tr"
      "ml mm mr"
      "ml mm mr"
      "ml mm mr"
      "bl bm br"
      "bl bm br"
      "bl bm br";
    align-items: start;
    column-gap: var(--col-gap);
    row-gap: var(--row-gap);
  }

  @media screen and (min-width: 640px) {
    .ui-container-inner {
      display: grid;
      grid-column: 1 / 2;
      grid-row: 2 / span 1;
      grid-template-columns: 300px 1fr 300px;
      grid-template-rows: repeat(9, minmax(0, 1fr));
      grid-template-areas:
        "tl tm tr"
        "tl tm tr"
        "tl tm tr"
        "ml mm mr"
        "ml mm mr"
        "ml mm mr"
        "bl bm br"
        "bl bm br"
        "bl bm br";
      align-items: start;
    }
  }
</style>
