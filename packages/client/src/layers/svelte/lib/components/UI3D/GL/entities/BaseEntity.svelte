<script lang="ts">
  // TYPES
  import type { Entity } from "../../../../../modules/entities";

  // GAME
  import { addressToColor } from "../../../../../utils/ui";
  import { playerCore } from "../../../../../modules/player";

  // GL
  import { Mesh, T } from "@threlte/core";
  import { MeshBasicMaterial, BoxGeometry, SphereGeometry, Vector3 } from "three";
  import { DEG2RAD } from "three/src/math/MathUtils";

  // SVELTE
  import { onMount } from "svelte";
  import { createEventDispatcher } from "svelte";
  import { tweened, spring } from "svelte/motion";

  // THREE
  import Camera from "../Camera.svelte";
  import Model from "../Model.svelte";

  export let id: string;
  export let entity: Entity;

  const dispatch = createEventDispatcher();
  const opacity = tweened(0, { duration: 200 });
  const color = addressToColor(id);

  const onClick = ({ detail: { object } }) => {
    dispatch("click", object);
  };

  let { position } = entity;

  const p = tweened(position, { duration: 1000 });

  $: p.set(entity.position);

  onMount(() => {
    opacity.set(0);
  });
</script>

<Mesh
  interactive
  on:click={onClick}
  geometry={new BoxGeometry(1, 1, 1)}
  material={new MeshBasicMaterial({ color, transparent: true, opacity: $opacity })}
  position={{ x: $p.x, y: 0.5, z: $p.y }}
>
  <slot />

  {#if id === $playerCore?.carriedBy}
    <Model />
    <Camera />
  {/if}
</Mesh>
