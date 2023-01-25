<script lang="ts">
  import Stats from "three/examples/jsm/libs/stats.module.js";
  import { useFrame } from "@threlte/core";
  import { onMount } from "svelte";

  export let container: HTMLElement = document.body;

  const stats = new Stats();

  const init = () => {
    container.appendChild(stats.dom);
  };

  useFrame(() => {
    stats.update();
  });

  onMount(init);
</script>
