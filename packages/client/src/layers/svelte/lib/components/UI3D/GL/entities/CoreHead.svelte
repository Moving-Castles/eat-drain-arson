<script lang="ts">
  import { GLTF } from "@threlte/extras";
  import { useTexture, useFrame } from "@threlte/core";
  import { MeshBasicMaterial, Vector2, Vector3, DoubleSide } from "three";
  import { DEG2RAD } from "three/src/math/MathUtils";

  export let id: string;
  export let scale: number;
  export let position: Vector3;

  let model;
  let loaded = false;
  let ry = 0;

  const seedToRandomMask = (id: string) => {
    const x = Math.floor(Math.random() * 5);
    const y = Math.floor(Math.random() * 5);

    return { x, y };
  };

  const map = useTexture("/images/tilesets/CoreTextures.png", {
    onLoad: () => {
      loaded = true;
      const { x, y } = seedToRandomMask(id);
      map.repeat = new Vector2(0.2, 0.2);
      map.offset = new Vector2(x / 5, y / 5);
      map.unpackAlignment = 4;
      map.wrapS = 1000;
      map.wrapT = 1000;
      map.flipY = false;

      console.log(map);
    },
  });

  $: if (model && loaded) {
    // Now assign a portion of the material to the mesh

    model.scene.traverse((node) => {
      if (node.userData.name === "Core.Basic_01") {
        node.material = new MeshBasicMaterial({
          side: 2,
          map,
        });
      }
    });
  }

  useFrame((d) => {
    // position.x += Math.sin(d.clock.elapsedTime * 10) / 100;
    scale += Math.cos(d.clock.elapsedTime) / 500;
    ry += Math.cos(d.clock.elapsedTime) / 100;
  });
</script>

<GLTF
  {position}
  rotation={{ y: DEG2RAD * 90 - ry }}
  {scale}
  url="/models/Core-Mesh_01.glb"
  useDraco
  bind:gltf={model}
/>
