<script lang="ts">
  import { GLTF } from "@threlte/extras";
  import { T } from "@threlte/core";
  import { DEG2RAD } from "three/src/math/MathUtils";

  export let UNIT: number;

  const architecture = [
    "arch1.glb",
    "arch2.glb",
    "arch3.glb",
    "column1.glb",
    "column2.glb",
    "column3.glb",
    "column4.glb",
    "column5.glb",
    "column6.glb",
    "wall03.glb",
    "wall04.glb",
    "wall05.glb",
    "wall06.glb",
  ];

  const randomModel = architecture[Math.floor(Math.random() * architecture.length)];
</script>

<T.Object3D rotation.x={DEG2RAD * 90} rotation.z={Math.random() * DEG2RAD * 45 - DEG2RAD * 90}>
  <GLTF scale={0.5} url="/models/architecture/{randomModel}" />
</T.Object3D>
