<script>
  import { T, InstancedMesh, Instance } from "@threlte/core";
  import { SphereGeometry } from "three";
</script>

<InstancedMesh>
  <Instance position={{ x: 0, y: 3, z: 0 }} castShadow>
    <T.SphereGeometry />
    <T.MeshStandardMaterial color="#000000" />
  </Instance>
</InstancedMesh>
