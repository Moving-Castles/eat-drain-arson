<script lang="ts">
  // GAME
  import { addressToColor } from "../../../../../utils/ui";

  // GL
  import { Mesh } from "@threlte/core";
  import { MeshBasicMaterial, BoxGeometry, SphereGeometry, Vector3 } from "three";
  import { DEG2RAD } from "three/src/math/MathUtils";
  // SVELTE
  import { onMount } from "svelte";
  import { tweened, spring } from "svelte/motion";

  export let id;
  export let entity;

  const opacity = tweened(0, { duration: 200 });
  const color = addressToColor(id);

  const onClick = ({ detail: { object } }) => {
    console.log(object);
  };

  let { position } = entity;

  console.log(position.x, position.y);

  const p = spring(position, { stiffness: 0.9, damping: 0.25 });

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
  position={{ x: $p.x, y: 1, z: $p.y }}
>
  <slot />
</Mesh>
