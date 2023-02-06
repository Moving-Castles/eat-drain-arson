<script lang="ts">
  import { activeTransactions } from "../../../modules/network";
  import { shortenAddress } from "../../../utils/ui";
</script>

<div class="ui-transactions">
  {#each $activeTransactions as tx}
    <div><span class="description">{tx.description}</span> {shortenAddress(tx.hash)}</div>
  {/each}
</div>

<style>
  .description {
    background: white;
    color: black;
    padding: 2px;
  }
</style>
