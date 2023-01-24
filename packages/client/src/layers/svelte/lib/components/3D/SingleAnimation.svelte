<script lang="ts">
  import { GLTF, useGltfAnimations } from "@threlte/extras";

  export let url = "/models/NewBodies_110123_03.glb";
  export let animationKey = "idle"; // this will be decided via prop

  const { gltf } = useGltfAnimations(({ actions }) => {
    // Uncomment to see all the different possible action keys
    // console.log(actions);
    // set the initial animation
    actions[animationKey]?.play();
  });
</script>

<GLTF bind:gltf={$gltf} {url} useDraco />
