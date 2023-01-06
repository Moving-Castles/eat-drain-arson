<script lang="ts">
  import { Canvas, T, PerspectiveCamera, OrbitControls } from "@threlte/core";
  import { Vector3 } from "three";

  import Character from "../3D/Character.svelte";
</script>

<Canvas>
  <PerspectiveCamera lookAt={new Vector3(0, 100, 0)} position={{ x: 10 }} fov={80}>
    <OrbitControls enableDamping enableZoom={false} enablePan={false} minPolarAngle={1} maxPolarAngle={1} />
  </PerspectiveCamera>
  <T.Group scale={5} position={[0, -4, 0]}>
    <Character />
  </T.Group>
</Canvas>
