<script lang="ts">
  import { activeTransactions2 } from "../../modules/network";
  import { shortenAddress } from "../../utils/ui";
</script>

<div class="ui-transactions">
  {#each $activeTransactions2 as tx (tx.hash)}
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
