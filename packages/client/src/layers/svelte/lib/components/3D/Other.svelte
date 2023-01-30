<script lang="ts">
  import { T } from "@threlte/core";
  import { DEG2RAD } from "three/src/math/MathUtils";
  import type { Player } from "../../../modules/entities";
  import SingleAnimation from "./SingleAnimation.svelte";

  export let other: Player;

  const NORTH = DEG2RAD * -180;

  // let rotation = 0;
</script>

{#if other}
  <T.Group position.x={other.position.x} position.z={other.position.y} scale={0.3} rotation.y={NORTH}>
    <SingleAnimation animationKey="walk" />
  </T.Group>
{/if}
