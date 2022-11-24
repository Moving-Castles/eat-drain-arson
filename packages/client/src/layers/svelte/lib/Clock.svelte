<script lang="ts">
  import { blockNumber } from "../stores/network";

  const SECONDS_IN_DAY = 86400;

  let clockTime: number;
  $: clockTime = Math.floor((($blockNumber % 3600) / 3600) * SECONDS_IN_DAY);

  function isNight(date: Date) {
    return date.getHours() > 17 || date.getHours() < 9;
  }

  function formatTime(seconds: number) {
    let currentTime = new Date(seconds * 1000);
    return (isNight(currentTime) ? "[night] " : "[day] ") + currentTime.toISOString().substr(11, 8);
  }
</script>

<div class="clock">
  <div class="clock-time">{formatTime(clockTime)} – {$blockNumber}</div>
</div>

<style>
  .clock {
    border: 1px solid white;
    color: white;
    padding: 10px;
    user-select: none;
    cursor: pointer;
  }
</style>
