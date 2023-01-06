<script lang="ts">
  import { textureSources, textures } from ".;
  import { T, TransformableObject, useTexture } from "@threlte/core";
  import Tile from "./Tile.svelte";

  $textures = useTexture(Object.values(textureSources), {
    onError: (error) => {
      console.warn(`An error occured loading the texture: ${error.message}`);
    },
    onLoad: (e) => {
      console.log("Texture loaded", e, textures);
    },
  });
</script>

<T.Group>
  <T.OrthographicCamera zoom={80} let:ref={cam} position={[0, 5, 10]} makeDefault>
    <TransformableObject object={cam} lookAt={{ y: 0 }} />
  </T.OrthographicCamera>
</T.Group>

<!-- <T.Group rotation.y={rotation} position.y={-2}>
  <GLTF scale={3} castShadow receiveShadow url={"/src/public/models/Animations_02.glb"} interactive useDraco />
  <T.Mesh receiveShadow rotation.x={DEG2RAD * -90}>
    <T.CircleGeometry args={[4, 60]} />
    <T.MeshStandardMaterial color="#000000" args={[0xff0000]} />
  </T.Mesh>
</T.Group> -->

<T.Group>
  <Tile />
</T.Group>

<T.DirectionalLight position={[0, 10, 10]} castShadow />
<T.DirectionalLight position={[0, 10, -10]} intensity={0.2} />
<T.AmbientLight intensity={0.5} />
