<script lang="ts">
  import { T } from "@threlte/core";
  import { playerPosition } from "../../../modules/sequencer/interpolation";
  import { DEG2RAD } from "three/src/math/MathUtils";
  import Character from "./Character.svelte";

  const NORTH = DEG2RAD * -180;

  let rotation = 0;
</script>

{#if $playerPosition?.x && $playerPosition?.y}
  <T.Group position.x={$playerPosition.x} position.z={$playerPosition.y} scale={0.3} rotation.y={NORTH}>
    <Character />
  </T.Group>
{/if}
