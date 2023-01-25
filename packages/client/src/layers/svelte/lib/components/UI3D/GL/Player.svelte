<script lang="ts">
  import { T } from "@threlte/core";
  import { blockNumber } from "../../../../modules/network";
  // import { tweened } from "svelte/motion";
  import { player, playerPositionX, playerPositionY } from "../../../../modules/player";
  import { DEG2RAD } from "three/src/math/MathUtils";
  import { isEqual } from "lodash";

  import Model from "./Model.svelte";

  const NORTH = DEG2RAD * -180;
  const MS = 1000; // millis

  let rotation = 0;

  /**
   * Abstract model for animations
   * With an example for position
   */
  // Since we immediately have the updated value of the entity's component at the begin of the blockNumber,
  // we can just interpolate based off of the component value, instead of immediately updating the component
  // All we need to know is

  // 1. What the new value is
  // --> We know this from the beginning of the blockNumber
  // 2. What the previous value was
  // --> We can get this by subscribing to the component value
  // 3. What the duration of the animation should be.
  // This could be read off the active operation
  // But for other player animations etc.
  // Ideally we can do this without ever seeing the active operation but just by deriving from the play state
  // So instead this should be based off the cooldownblock value

  // 4?. The tween should be cancelable somehow
  // 5?. The easing should be adjustable

  // USE CASE 1: POSITION
  // Every time there is a move

  // Store previous player state
  let previousPlayerState: any = null;

  // playerPositionX.set($player.position.x);
  // playerPositionY.set($player.position.y);

  player.subscribe((newPlayerState) => {
    console.log("player");
    console.log(newPlayerState);
    if (!!previousPlayerState && !isEqual(newPlayerState.position, previousPlayerState?.position)) {
      // Blocks to cooldown is (current block + 1) - cooldown block
      const duration = ($blockNumber + 1 - parseInt(newPlayerState.coolDownBlock)) * MS;
      console.log("DURATION: ", duration);
      // Now assign a tweened to that property that you can use in the templates
      playerPositionX.set(newPlayerState.position.x, { duration: 10000 });
      playerPositionY.set(newPlayerState.position.y, { duration: 10000 });
    }

    previousPlayerState = { ...newPlayerState };
  });

  // $: console.log($playerPositionX, $playerPositionY);
</script>

<T.Group position.x={$playerPositionX} position.z={$playerPositionY} scale={0.3} rotation.y={NORTH}>
  {#if $player.energy > 0}
    <Model animationKey="idle" />
  {:else}
    <T.Group rotation.x={DEG2RAD * 90} position.y={2} position.z={-1}>
      <SingleAnimation animationKey="idle" />
    </T.Group>
  {/if}
</T.Group>
