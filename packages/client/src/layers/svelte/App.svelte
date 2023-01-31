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
    createMatterSystem,
    createReadyBlockSystem,
    createCoreSystem,
    createCarriedBySystem,
    createPortableSystem,
    createCarryingCapacitySystem,
    createAbilityMoveSystem,
    createAbilityConsumeSystem,
    createAbilityExtractSystem,
    createUntraversableSystem,
    createGameConfigSystem,
  } from "./systems";
  import { network as networkStore, blockNumber, startBlock } from "./modules/network";

  onMount(async () => {
    const layers = await bootGame();

    // ---- Systems
    createLoadingStateSystem(layers.network);
    createPositionSystem(layers.network);
    createCreationBlockSystem(layers.network);
    createReadyBlockSystem(layers.network);
    createEnergySystem(layers.network);
    createMatterSystem(layers.network);
    createPortableSystem(layers.network);
    createCarryingCapacitySystem(layers.network);
    createCarriedBySystem(layers.network);
    createCoreSystem(layers.network);
    createAbilityMoveSystem(layers.network);
    createAbilityConsumeSystem(layers.network);
    createAbilityExtractSystem(layers.network);
    createUntraversableSystem(layers.network);
    createGameConfigSystem(layers.network);

    networkStore.set(layers.network);

    layers.network.txReduced$.subscribe((tx) => {
      console.log("TX:", tx);
      // transactions.update((ts) => [tx, ...ts]);
    });

    // startEnvironmentSoundSystem();
    // startMelodySoundSystem();
    // startHarmonySoundSystem();

    layers.network.network.blockNumber$.subscribe((x) => {
      // console.log(x);
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
