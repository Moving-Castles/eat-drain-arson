<script>
  export let label;
  export let key;
  // You can also pass the value
  export let value = undefined; // You can pass a store

  import { entities } from "../../modules/entities";
  import { player } from "../../modules/player";
  import { blockNumber } from "../../modules/network";
  import { tweened } from "svelte/motion";

  let direction;
  let timeout;
  let readonly;

  if (!value) {
    value = tweened($player[key]);
  } else {
    readonly = true;
  }

  if (!readonly) {
    entities.subscribe((v) => {
      // clearTimeout(timeout)
      let duration = ($player.coolDownBlock - $blockNumber) * 1000;
      duration = duration > 0 ? duration : 1000;

      let newValue = $player[key];
      direction = Math.sign(newValue - $value);

      if (newValue !== $value) {
        clearTimeout(timeout);
        value.set(newValue, { duration });
        timeout = setTimeout(resetDirection, duration);
      }
    });
  }

  function resetDirection() {
    direction = 0;
  }
</script>

<div class="large-indicator">
  <div class="label">{label}</div>
  <div class="value" class:up={direction > 0} class:down={direction < 0}>
    <span>{Math.round($value)}</span>
  </div>
</div>

<style>
  .large-indicator {
    display: flex;
    width: 100%;
    border-width: 1px;
    text-align: center;
    margin-top: calc(var(--row-gap) / 3);
    border: var(--outer-border);
    overflow: hidden;
  }

  .label {
    width: 120px;
    flex-shrink: 0;
    background: rgba(var(--foreground-rgb), 0.3);
    color: var(--foreground);
    padding: 4px 12px;
    font-weight: bold;
  }

  .stats {
    padding-top: 1rem;
    align-self: start;
    display: flex;
    gap: var(--col-gap);
  }

  .value {
    width: 100%;
    align-self: center;
    font-weight: bold;
  }

  .up {
    animation: 1s up linear forwards;
  }

  .down {
    animation: 1s down linear forwards;
  }

  @keyframes up {
    to {
      color: var(--success);
    }
  }

  @keyframes down {
    to {
      color: var(--failure);
    }
  }
</style>
