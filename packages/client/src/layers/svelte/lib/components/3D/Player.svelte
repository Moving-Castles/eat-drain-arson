<script lang="ts">
  import { T, useFrame, InteractiveObject } from "@threlte/core";
  import { MeshStandardMaterial, PlaneGeometry } from "three";
  import { DEG2RAD } from "three/src/math/MathUtils";
  import { player } from "../../../modules/player";
  import Character from "./Character.svelte";
  const NORTH = DEG2RAD * -180;

  let rotation = 0;

  console.log($player.position.x);

  const next = () => {
    console.log("next");
  };
  useFrame(() => {
    rotation += 0.002;
  });
</script>

<T.Group
  position.x={$player.position.x}
  position.z={$player.position.y}
  scale={0.15}
  rotation.y={NORTH - DEG2RAD * (45 + 90)}
>
  <Character />
</T.Group>
