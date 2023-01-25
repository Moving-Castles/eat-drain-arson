<script lang="ts">
  import UIDied from "../../UIDied.svelte";
  import UI3DAvatar from "../UI3D/UI3DAvatar.svelte";
  import { playSound } from "../../../../howler";
  import UIMetric from "../UIMetric.svelte";
  import { Activities, activityToVerb, player, playerActivity, dead } from "../../../modules/player";
  import { seedToName, seedToMask } from "../../../utils/name";
  import { EntityType } from "../../../modules/entities";
  import { Howl } from "howler";

  let activitySound: Howl;

  playerActivity.subscribe((activity) => {
    if (activitySound && activitySound.playing()) {
      activitySound.stop();
    }

    if (activity === Activities.Moving) {
      activitySound = playSound("walking", "activity", true);
    }
    if (activity === Activities.Eating) {
      activitySound = playSound("eating", "activity", true);
    }
    if (activity === Activities.Gathering) {
      activitySound = playSound("digging", "activity", true);
    }
    if (activity === Activities.Burning) {
      activitySound = playSound("fire", "environment", true);
    }
    if (activity === Activities.Idle) {
      activitySound = playSound("idle", "activity", true);
    }
    if (activity === Activities.Playing) {
      activitySound = playSound(String(seedToMask($player.seed || 0)), "play", true);
    }
    if (activity === Activities.Dead) {
      activitySound = playSound("death", "ui");
    }
  });
</script>

<div class="ui-avatar">
  <div
    class="ui-avatar-header"
    class:overlay={$player.entityType == EntityType.Corpse}
    class:corpse={$player.entityType == EntityType.Corpse}
  >
    <div class="name">
      {seedToName($player.seed)}
    </div>
    <div class="activity">
      {#if $player.entityType == EntityType.Corpse}
        (dead)
      {:else}
        ({activityToVerb($playerActivity)})
      {/if}
    </div>
  </div>

  <div class="ui-avatar-3d">
    <UI3DAvatar />
  </div>

  <div class="resources">
    <UIMetric label="Energy" key="energy" />
    <UIMetric label="Sludge" key="resource" />
  </div>

  <!-- <div class="ui-avatar-video">
    {#if $player.entityType == EntityType.Corpse}
      <video src={"/animations/" + seedToMask($player.seed) + "/Die.mp4"} autoplay muted />
    {:else if $playerActivity === Activities.Moving}
      <video src={"/animations/" + seedToMask($player.seed) + "/Walk.mp4"} autoplay muted loop />
    {:else if $playerActivity === Activities.Eating}
      <video src={"/animations/" + seedToMask($player.seed) + "/Eat.mp4"} autoplay muted loop />
    {:else if $playerActivity === Activities.Gathering}
      <video src={"/animations/" + seedToMask($player.seed) + "/Gather.mp4"} autoplay muted loop />
    {:else if $playerActivity === Activities.Burning}
      <video src={"/animations/" + seedToMask($player.seed) + "/Fire.mp4"} autoplay muted loop />
    {:else if $playerActivity === Activities.Playing}
      <video src={"/animations/" + seedToMask($player.seed) + "/Play.mp4"} autoplay muted loop />
    {:else if $playerActivity === Activities.Dead}
      <video src={"/animations/" + seedToMask($player.seed) + "/Die.mp4"} autoplay muted />
    {:else}
      <video src={"/animations/" + seedToMask($player.seed) + "/Idle.mp4"} autoplay muted loop />
    {/if}
  </div> -->

  {#if $dead}
    <div class="ui-overlay">
      <UIDied />
    </div>
  {/if}
</div>

<style>
  .ui-overlay {
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
  }
  .activity {
    text-align: center;
    width: 100%;
    grid-column: 1 / 3;
  }

  .ui-avatar-3d {
    position: relative;
    height: 100%;
    width: 100%;
  }

  .ui-avatar {
    position: relative;
    height: 100%;
    display: flex;
    flex-flow: column nowrap;
    justify-content: space-between;
    align-items: stretch;
  }

  .ui-avatar-video {
    position: absolute;
    top: 0;
    right: 0;
    bottom: 0;
    left: 0;
    z-index: -1;
    width: 100%;
    height: 100%;
  }

  video {
    width: 100%;
    height: 100%;
    object-fit: contain;
    object-position: center;
    display: block;
    margin-left: auto;
    margin-right: auto;
  }

  .ui-avatar-header {
    display: grid;
    grid-template-columns: repeat(2, minmax(0, 1fr));
    grid-auto-rows: auto;
    gap: 4px;
    position: relative;
  }

  .ui-avatar-header:after {
    background-size: contain !important;
    background-repeat: no-repeat;
  }

  .name {
    /* font-size: var(--font-size-large); */
    text-align: center;
    grid-column: 1 / 3;
    /* font-weight: bold; */
  }
</style>
