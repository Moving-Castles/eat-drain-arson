<script lang="ts">
  import { onMount } from "svelte";
  import { bootGame } from "./boot";
  import UIContainer from "./components/UI/UIContainer.svelte";
  import UIMenu from "./components/UI/UIMenu.svelte";
  import { createComponentSystem, createLoadingStateSystem } from "./systems";
  import { network as networkStore, blockNumber, transactions, executedTransactions } from "./modules/network";

  onMount(async () => {
    const layers = await bootGame();

    networkStore.set(layers.network);

    // Create systems to listen to component changes
    for (const componentKey of Object.keys(layers.network.components)) {
      if (componentKey === "LoadingState") {
        createLoadingStateSystem(layers.network);
      } else {
        createComponentSystem(layers.network, componentKey);
      }
    }

    const EXCLUDED_SYSTEMS = ["system.ComponentDev", "system.Init", "system.Spawn"];

    // Listen to all system call streams
    for (const [key, value] of Object.entries(layers.network.systemCallStreams)) {
      if (!EXCLUDED_SYSTEMS.includes(key)) {
        value.subscribe((systemCall) => {
          // If local, mark transaction as executed
          if ($transactions.find((t) => t.hash === systemCall.tx.hash)) {
            executedTransactions.update((value) => [...value, systemCall.tx.hash]);
          }
        });
      }
    }

    layers.network.network.blockNumber$.subscribe((x) => {
      blockNumber.set(x);
    });
  });
</script>

<UIMenu />

<main>
  <UIContainer />
</main>
