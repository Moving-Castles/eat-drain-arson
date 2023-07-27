<script lang="ts">
  import { gameConfig } from "../../modules/entities";
  console.log($gameConfig);
</script>

<div class="game-config">
  {#each Object.entries($gameConfig) as [key, value] (key)}
    <div><strong>{key}:</strong> {value}</div>
  {/each}
</div>
