<script lang="ts">
  import { GLTF, useGltfAnimations } from "@threlte/extras";
  import { DEG2RAD } from "three/src/math/MathUtils";
  import { MeshBasicMaterial } from "three";

  export let scale = 1;
  export let url = "/models/CharacterSkeletonMesh_01.glb";
  export let animationKey = "Idle"; // this will be decided via prop

  const { gltf } = useGltfAnimations(({ actions }) => {
    // Uncomment to see all the different possible action keys
    console.log(actions);
    console.log($gltf);
    // set the initial animation
    // play();
    Math.random() > 0.25 || actions[animationKey]?.play();
  });

  function play() {
    // actions[animationKey]?.play();
  }

  /** Convert to MeshBasic for no light setup */
  $: if ($gltf) {
    $gltf.scene.traverse((node) => {
      if (node.material) {
        node.material = new MeshBasicMaterial({
          side: 2,
          map: node.material.map,
        });
      }
    });
  }
</script>

<GLTF rotation={{ y: DEG2RAD * 90 }} position={{ x: 0.5, z: 0.5 }} {scale} bind:gltf={$gltf} {url} useDraco />

<slot name="cores" />
