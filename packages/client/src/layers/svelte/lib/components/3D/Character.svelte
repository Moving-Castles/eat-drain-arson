<script lang="ts">
  import Compass from "./Compass.svelte";
  import { T } from "@threlte/core";
  import { GLTF, useGltfAnimations } from "@threlte/extras";
  import { MeshBasicMaterial } from "three";
  // import { PointLight, Mesh, MeshBasicMaterial, SphereGeometry } from "three";

  let currentActionKey = "walk";

  console.log("play on playa");

  let available = true;

  const { gltf, actions } = useGltfAnimations(({ actions }) => {
    // Uncomment to see all the different possible action keys
    // console.log(actions);
    // set the initial animation
    actions[currentActionKey]?.play();
    if ($gltf?.scene) {
      // $gltf.scene.traverse((node) => {
      //   console.log(node);
      // });
    }
  });

  function transitionTo(nextActionKey: string, duration = 1) {
    available = false;
    setTimeout(() => {
      available = true;
    }, duration * 1000);
    const currentAction = $actions[currentActionKey];
    const nextAction = $actions[nextActionKey];
    if (!nextAction || currentAction === nextAction) return;
    // Function inspired by: https://github.com/mrdoob/three.js/blob/master/examples/webgl_animation_skinning_blending.html
    nextAction.enabled = true;
    if (currentAction) {
      currentAction.crossFadeTo(nextAction, duration, true);
    }
    // Not sure why I need this but the source code does not
    nextAction.play();
    currentActionKey = nextActionKey;
  }

  function handleKeyPress(e) {
    switch (e.key) {
      case "r":
        random();
      case "k":
        kill();
      case "g":
        gather();
      case "w":
        walk();
      default:
        break;
    }
  }

  function random() {
    const options = Object.keys($actions).filter((key) => key !== currentActionKey);
    const randomAction = options[Math.floor(Math.random() * options.length)];

    if (available) {
      transitionTo(randomAction);
    }
  }

  function kill() {
    if (available) {
      transitionTo("Hips.001|Unreal Take|Base Layer");
    }
  }

  function gather() {
    if (available) {
      transitionTo("Pickup");
    }
  }

  function walk() {
    if (available) {
      transitionTo("walkForward");
    }
  }
</script>

<svelte:window on:keypress={handleKeyPress} />

<GLTF bind:gltf={$gltf} url="/models/NewBodies_110123_03.glb" useDraco />
