<script lang="ts">
  // TYPES
  import type { Entity } from "../../../../../modules/entities";

  // GAME
  import { addressToColor } from "../../../../../utils/ui";
  import { playerCore } from "../../../../../modules/player";

  // GL
  import { Mesh } from "@threlte/core";
  import { MeshBasicMaterial, BoxGeometry, SphereGeometry, Vector3 } from "three";
  import { DEG2RAD } from "three/src/math/MathUtils";

  // SVELTE
  import { onMount } from "svelte";
  import { tweened, spring } from "svelte/motion";

  // THREE
  import Camera from "../Camera.svelte";

  export let id: string;
  export let entity: Entity;

  const opacity = tweened(0, { duration: 200 });
  const color = addressToColor(id);

  const onClick = ({ detail: { object } }) => {
    console.log(object);
  };

  let { position } = entity;

  console.log(position.x, position.y);

  const p = tweened(position, { duration: 1000 });

  $: p.set(entity.position);

  onMount(() => {
    opacity.set(1);
  });
</script>

<Mesh
  interactive
  on:click={onClick}
  geometry={new BoxGeometry(0.5, 0.5, 0.5)}
  material={new MeshBasicMaterial({ color, transparent: true, opacity: $opacity })}
  position={{ x: $p.x, y: 0.5, z: $p.y }}
>
  <slot />

  {#if id === $playerCore?.carriedBy}
    <Camera />
  {/if}
</Mesh>
