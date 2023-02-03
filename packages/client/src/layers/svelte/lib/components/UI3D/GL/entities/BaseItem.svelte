<script lang="ts">
  // TYPES
  import type { Entity } from "../../../../../modules/entities";

  // GAME
  import { addressToColor } from "../../../../../utils/ui";
  import { playerCore } from "../../../../../modules/player";
  import { isTraversable, getInventory, hasPlayer, getCores } from "../../../../../modules/entities";

  // GL
  import { Mesh, Group } from "@threlte/core";
  import { MeshBasicMaterial, BoxGeometry } from "three";

  // SVELTE
  import { onMount } from "svelte";
  import { createEventDispatcher } from "svelte";
  import { tweened, spring } from "svelte/motion";
  import { cubicInOut } from "svelte/easing";

  // THREE
  // import Model from "../Model.svelte";

  export let id: string;
  export let entity: Entity;

  console.log(id, entity);

  console.log("hello from base item", entity);

  // const p = tweened(position, { duration: 1000, easing: cubicInOut });
</script>

<!-- <Group position={{ x: $p.x, y: 0.5, z: $p.y }}>
  <Mesh geometry={new BoxGeometry(0.2, 0.2, 0.2)} material={new MeshBasicMaterial({ color: 0xff0000 })} />
</Group> -->
