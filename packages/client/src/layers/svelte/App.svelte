<script lang="ts">
  import { startEnvironmentSoundSystem, startMelodySoundSystem, startHarmonySoundSystem } from "../howler";
  import { onMount } from "svelte";
  import { bootGame } from "./boot";
  import UIContainer from "./lib/UIContainer.svelte";
  import UIMenu from "./lib/UIMenu.svelte";
  import {
    createLoadingStateSystem,
    createPositionSystem,
    createCreationBlockSystem,
    createEnergySystem,
    createResourceSystem,
    createCoolDownSystem,
    createSeedSystem,
    createEntityTypeSystem,
    createCreatorSystem,
    createStatsSystem,
    createCannibalSystem,
    createPlayingSystem,
    createDeathSystem,
  } from "./systems";
  import { network as networkStore, blockNumber, startBlock } from "./modules/network";
  import { entities } from "./modules/entities";
  import { player } from "./modules/player";
  import { transactions, receipts, activeTransactions } from "./modules/network";

  $: console.log("$entities", $entities);
  $: console.log("$player", $player);

  // $: {
  //   console.log("___ Transactions store: ", $transactions);
  // }

  // $: {
  //   console.log("___ Receipts store: ", $receipts);
  // }

  // $: {
  //   console.log("___ activeTransactions:", $activeTransactions);
  // }

  onMount(async () => {
    const layers = await bootGame();

    // ---- Systems
    createLoadingStateSystem(layers.network);
    createPositionSystem(layers.network);
    createCreationBlockSystem(layers.network);
    // createEnergySystem(layers.network);
    // createResourceSystem(layers.network);
    // createCoolDownSystem(layers.network);
    // createSeedSystem(layers.network);
    // createEntityTypeSystem(layers.network);
    // createCreatorSystem(layers.network);
    // createStatsSystem(layers.network);
    // createCannibalSystem(layers.network);
    // createPlayingSystem(layers.network);
    // createDeathSystem(layers.network);

    networkStore.set(layers.network);

    layers.network.txReduced$.subscribe((tx) => {
      console.log("TX:", tx);
      // transactions.update((ts) => [tx, ...ts]);
    });

    // startEnvironmentSoundSystem();
    // startMelodySoundSystem();
    // startHarmonySoundSystem();

    layers.network.network.blockNumber$.subscribe((x) => {
      console.log(x);
      blockNumber.set(x);
      if ($startBlock == 0) {
        startBlock.set(x);
      }
    });
  });
</script>

<UIMenu />

<main>
  <UIContainer />
</main>
