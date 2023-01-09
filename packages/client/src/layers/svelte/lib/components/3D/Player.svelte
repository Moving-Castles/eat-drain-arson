<script lang="ts">
  import { T, useFrame, InteractiveObject } from "@threlte/core";
  import { MeshStandardMaterial, PlaneGeometry } from "three";
  import { DEG2RAD } from "three/src/math/MathUtils";
  import Character from "./Character.svelte";
  const NORTH = DEG2RAD * -180;

  let rotation = 0;

  const next = () => {
    console.log("next");
  };
  useFrame(() => {
    rotation += 0.002;
  });
</script>

<T.Group scale={0.16} rotation.y={NORTH}>
  <Character />

  <!-- Local floor -->
  <!-- <T.Mesh position.y={0.05} rotation.x={DEG2RAD * -90} rotation.z={DEG2RAD * -90} receiveShadow>
    <T.PlaneGeometry args={[10, 10]} />
    <T.MeshStandardMaterial color="#ff0000" transparent={true} opacity={0.5} />
  </T.Mesh> -->
</T.Group>
