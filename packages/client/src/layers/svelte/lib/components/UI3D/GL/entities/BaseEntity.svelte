<script lang="ts">
  // GAME
  import { addressToColor } from "../../../../../utils/ui";

  // GL
  import { Mesh } from "@threlte/core";
  import { MeshBasicMaterial, BoxGeometry, SphereGeometry, Vector3 } from "three";
  import { DEG2RAD } from "three/src/math/MathUtils";
  // SVELTE
  import { onMount } from "svelte";
  import { tweened } from "svelte/motion";

  export let id;
  export let entity;

  const opacity = tweened(0, { duration: 200 });
  const color = addressToColor(id);

  const onClick = ({ detail: { object } }) => {
    console.log(object);
  };

  onMount(() => {
    opacity.set(1);
  });
</script>

<Mesh
  interactive
  on:click={onClick}
  geometry={new BoxGeometry(0.5, 0.5, 0.5)}
  material={new MeshBasicMaterial({ color, transparent: true, opacity: $opacity })}
  position={new Vector3(entity.position.x, 0, entity.position.y)}
  rotation={new Vector3(0, DEG2RAD * 45, DEG2RAD)}
>
  <slot />
</Mesh>
