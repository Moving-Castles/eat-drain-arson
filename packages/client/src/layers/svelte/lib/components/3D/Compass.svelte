<script lang="ts">
  import { T } from "@threlte/core";
  import { DEG2RAD } from "three/src/math/MathUtils";
  import { DEV } from "../../../utils/ui";

  export let scale = 1;
  const NORTH = DEG2RAD * -90;
  const DIAL_LENGTH = 0.32;
</script>

<T.Group {scale}>
  <T.Mesh rotation.y={NORTH} rotation.z={DEG2RAD * 90} position.z={-DIAL_LENGTH / 2}>
    <T.ConeGeometry args={[0.05, 0.32, 40, 1, false, 0, Math.PI]} />
    <T.MeshBasicMaterial wireframe={DEV} color="#0000ff" />
  </T.Mesh>

  <T.Mesh rotation.y={-NORTH} rotation.z={DEG2RAD * 90} position.z={DIAL_LENGTH / 2}>
    <T.ConeGeometry args={[0.05, 0.32, 40, 1, false, 0, Math.PI]} />
    <T.MeshBasicMaterial wireframe={DEV} color="#ffffff" />
  </T.Mesh>
</T.Group>
