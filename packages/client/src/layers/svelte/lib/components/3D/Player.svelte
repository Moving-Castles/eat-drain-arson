<script lang="ts">
  import { T } from "@threlte/core";
  import { player } from "../../../modules/player";
  import { playerPosition } from "../../../modules/sequencer/interpolation";
  import { DEG2RAD } from "three/src/math/MathUtils";
  import SingleAnimation from "./SingleAnimation.svelte";

  const NORTH = DEG2RAD * -180;

  let rotation = 0;
</script>

<T.Group position.x={$player.position.x} position.z={$player.position.y} scale={0.3} rotation.y={NORTH}>
  {#if $player.energy > 0}
    <SingleAnimation animationKey="idle" />
  {:else}
    <T.Group rotation.x={DEG2RAD * 90} position.y={2} position.z={-1}>
      <SingleAnimation animationKey="idle" />
    </T.Group>
  {/if}
</T.Group>
