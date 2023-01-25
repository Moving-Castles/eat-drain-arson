<script lang="ts">
  // GAME
  import { addressToColor } from "../../../../../utils/ui";
  import { playerAddress } from "../../../../../modules/player";
  import type { Entity } from "../../../../../modules/entities";

  // GL
  import { Mesh, useFrame } from "@threlte/core";
  import { Text } from "@threlte/extras";
  import { MeshBasicMaterial, BoxGeometry, SphereGeometry, Vector3 } from "three";
  import { DEG2RAD } from "three/src/math/MathUtils";

  export let id: string;
  export let entity: Entity;

  const color = addressToColor(id);

  const onClick = (e) => {};

  const rotation = new Vector3(0, DEG2RAD, DEG2RAD);
  const position = new Vector3(0.1, 1, 0);
  let scale = 0.2;

  useFrame((d) => {
    // position.x += Math.sin(d.clock.elapsedTime * 10) / 100;
    scale += Math.cos(d.clock.elapsedTime * 10) / 500;
  });
</script>

<Mesh
  interactive
  on:click={onClick}
  geometry={new SphereGeometry(1, 10, 10)}
  material={new MeshBasicMaterial({ color })}
  {scale}
  {position}
  {rotation}
>
  {#if $playerAddress === id}
    <Text text="*" />
  {/if}

  <slot />
</Mesh>
