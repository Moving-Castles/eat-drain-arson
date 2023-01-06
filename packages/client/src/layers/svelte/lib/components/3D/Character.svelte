<script lang="ts">
  import { onDestroy } from "svelte";
  import { T, InteractiveObject } from "@threlte/core";
  import { GLTF, useGltfAnimations } from "@threlte/extras";

  let currentActionKey = "Pickup";
  let available = true;

  const { gltf, actions } = useGltfAnimations(({ actions }) => {
    // Uncomment to see all the different possible action keys
    // console.log(actions);
    // set the initial animation
    actions[currentActionKey]?.play();
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
        // console.log(e.key);
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

<GLTF bind:gltf={$gltf} url="/src/public/models/Animations_02.glb" useDraco />
