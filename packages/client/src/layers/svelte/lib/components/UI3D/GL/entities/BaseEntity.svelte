<script lang="ts">
  // WORLD WITH LOADS OF PLAYERS
  // http://localhost:3000/?dev=true&chainId=4242&worldAddress=0x2e452ec553d98BABe5505bd1ef14b0FA3e321170&rpc=https://follower.testnet-chain.linfra.xyz&wsRpc=wss://follower.testnet-chain.linfra.xyz&initialBlockNumber=5740793&snapshot=https://ecs-snapshot.testnet-mud-services.linfra.xyz&stream=https://ecs-stream.testnet-mud-services.linfra.xyz&relay=https://ecs-relay.testnet-mud-services.linfra.xyz&faucet=https://faucet.testnet-mud-services.linfra.xyz

  // TYPES
  import type { Entity } from "../../../../../modules/entities";

  // GAME
  import { addressToColor } from "../../../../../utils/ui";
  import { playerCore } from "../../../../../modules/player";
  import { isTraversable, getInventory, hasPlayer, getCores } from "../../../../../modules/entities";

  // GL
  import { Mesh, Group } from "@threlte/core";
  import { MeshBasicMaterial, CylinderGeometry, BoxGeometry } from "three";
  import { DEG2RAD } from "three/src/math/MathUtils";

  // SVELTE
  import { onMount } from "svelte";
  import { createEventDispatcher } from "svelte";
  import { tweened, spring } from "svelte/motion";
  import { cubicInOut } from "svelte/easing";

  // THREE
  import Core from "./Core.svelte";
  import BaseItem from "./BaseItem.svelte";
  //
  import Camera from "../Camera.svelte";
  import Model from "../Model.svelte";

  export let id: string;
  export let entity: Entity;

  let type = "";

  const dispatch = createEventDispatcher();
  const opacity = tweened(0, { duration: 200 });
  const color = addressToColor(id);
  let url = "";

  let { position } = entity;

  const p = tweened(position, { duration: 1000, easing: cubicInOut });

  $: p.set(entity.position);

  // Determine the base entity type
  // If the base entity has a player core inside,
  // and it is not a wall, then it is a player
  if (hasPlayer(id) && isTraversable(id)) {
    type = "skeleton";
  } else if (!isTraversable(id)) {
    type = "wall";
  }

  onMount(() => {
    opacity.set(0);
  });
</script>

<!-- BASE ENTITIES -->
<!-- SKELETON -->

<Group position={{ x: $p.x, y: 0.5, z: $p.y }}>
  <!-- EXTEND -->
  <slot />

  <!-- BASE IS A CYLINDER -->
  {#if type === "skeleton"}
    <!-- IF THE PLAYER IS ALIVE -->
    <Mesh
      interactive
      geometry={new CylinderGeometry(0.3, 0.3, 0.3, 32)}
      position={{ x: 0.5, z: 0.5, y: -0.3 }}
      material={new MeshBasicMaterial({ color: 0x00f000, wireframe: true })}
    />
  {:else if type === "wall"}
    <Mesh
      geometry={new BoxGeometry(1, 1, 0.1)}
      position={{ x: 0.5, z: 0.5, y: 0 }}
      rotation={{ y: DEG2RAD * 45 }}
      material={new MeshBasicMaterial({ color: 0xff0000, wireframe: true })}
    />
    <Mesh
      geometry={new BoxGeometry(1, 1, 0.1)}
      position={{ x: 0.5, z: 0.5, y: 0 }}
      rotation={{ y: DEG2RAD * -45 }}
      material={new MeshBasicMaterial({ color: 0xff0000, wireframe: true })}
    />
  {/if}
  <!-- CORE IS A SPHERE -->
  <!-- ITEMS ARE FLOATING AROUND LIKE AROUND A PLANET -->

  <!-- PLAYER -->
  {#each getCores(id) as [iid, iEntity], i (iid)}
    <Core {i} id={iid} entity={iEntity} />
  {/each}

  {#if id === $playerCore?.carriedBy}
    <Camera />
  {/if}
</Group>
