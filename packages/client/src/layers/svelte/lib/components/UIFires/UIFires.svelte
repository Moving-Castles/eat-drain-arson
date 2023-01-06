<script lang="ts">
  import { fires, EntityCategory } from "../../../modules/entities";
  import { blockNumber } from "../../../modules/network";

  import Fire from "./Fire.svelte";

  const remaining = (fire: EntityCategory.Fire) => Math.max((fire.coolDownBlock || 0) - $blockNumber, 0);

  let sortedFires = [...sorted(Object.entries($fires))];

  function sorted(entries) {
    let result = [...entries];

    result.sort(([ka, a], [kb, b]) => {
      if (remaining(a) === remaining(b)) {
        // Compare on secondary metric
        return b.resource - a.resource;
      } else {
        return remaining(b) - remaining(a);
      }
    });

    return result;
  }

  $: sortedFires = [...sorted(Object.entries($fires))];
</script>

<div class="ui-fires">
  {#if Object.entries($fires)?.length < 1}
    No fires in sight...
  {/if}

  {#each sortedFires as [address, value], i (address)}
    <Fire {address} {value} index={i} />
  {/each}
</div>
