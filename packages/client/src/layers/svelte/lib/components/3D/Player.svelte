<script lang="ts">
  import { T, useFrame, InteractiveObject } from "@threlte/core";
  import { DEG2RAD } from "three/src/math/MathUtils";
  import Character from "./Character.svelte";

  let rotation = 0;

  const next = () => {
    console.log("next");
  };
  useFrame(() => {
    rotation += 0.002;
  });
</script>

<T.Group scale={0.2}>
  <Character />
</T.Group>
