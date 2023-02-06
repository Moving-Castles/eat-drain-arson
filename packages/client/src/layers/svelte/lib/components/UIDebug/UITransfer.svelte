<script lang="ts">
  import type { Coord } from "@latticexyz/utils";
  import { chebyshev } from "../../../utils/space";
  import { network } from "../../../modules/network";
  import { entities } from "../../../modules/entities";
  import { playerCore } from "../../../modules/player";
  import { shortenAddress, addressToColor } from "../../../utils/ui";

  import Inventory from "./UIInventory.svelte";

  export let baseEntityId: string;

  import { createEventDispatcher } from "svelte";
  const dispatch = createEventDispatcher();

  function close() {
    dispatch("close", {});
  }
</script>

<div class="transfer">
  <div>
    Transfer to: <span style={"background:" + addressToColor(baseEntityId) + ";"}>
      {shortenAddress(baseEntityId)}
    </span>
  </div>
  <div class="inventory">
    <Inventory baseEntityId={$playerCore.carriedBy} targetBaseEntityId={baseEntityId} />
  </div>
  <div><button on:click={close}>CLOSE</button></div>
</div>

<style>
  .transfer {
    z-index: 1000000;
    padding: 40px;
    border: 3px solid black;
    background: lightgrey;
    color: black;
    font-size: 32px;
    position: fixed;
    top: 50%;
    left: 50%;
    transform: translateX(-50%) translateY(-50%);
    font-size: 16px;
  }

  .inventory {
    margin-top: 20px;
    margin-bottom: 20px;
    padding-top: 10px;
    padding-bottom: 10px;
    border-top: 1px solid black;
    border-bottom: 1px solid black;
  }
</style>
