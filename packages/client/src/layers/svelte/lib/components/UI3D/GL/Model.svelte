<script lang="ts">
  import { GLTF, useGltfAnimations } from "@threlte/extras";

  export let url = "/models/CharacterSkeletonMesh_01.glb";
  export let animationKey = "Idle"; // this will be decided via prop

  const { gltf } = useGltfAnimations(({ actions }) => {
    // Uncomment to see all the different possible action keys
    console.log(actions);
    // set the initial animation
    actions[animationKey]?.play();
  });

  $: if ($gltf) console.log($gltf);
</script>

<GLTF position={{ x: 0.5, z: 0.5 }} scale={1} bind:gltf={$gltf} {url} useDraco />
