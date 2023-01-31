<script lang="ts">
  // TYPES
  import type { Entity } from "../../../../../modules/entities";

  // GAME
  import { addressToColor } from "../../../../../utils/ui";
  import { playerCore } from "../../../../../modules/player";
  import { isWall, isPlayer, getInventory, getCores } from "../../../../../modules/entities";

  // GL
  import { Mesh, Group } from "@threlte/core";
  import { MeshBasicMaterial, BoxGeometry } from "three";

  // SVELTE
  import { onMount } from "svelte";
  import { createEventDispatcher } from "svelte";
  import { tweened, spring } from "svelte/motion";
  import { cubicInOut } from "svelte/easing";

  // THREE
  import Core from "./Core.svelte";
  //
  import Camera from "../Camera.svelte";
  import Model from "../Model.svelte";

  export let id: string;
  export let entity: Entity;

  const dispatch = createEventDispatcher();
  const opacity = tweened(0, { duration: 200 });
  const color = addressToColor(id);

  let { position } = entity;

  const p = tweened(position, { duration: 1000, easing: cubicInOut });

  $: p.set(entity.position);

  onMount(() => {
    opacity.set(0);
  });
</script>

<Group position={{ x: $p.x, y: 0.5, z: $p.y }}>
  <!-- EXTEND -->
  <slot />

  <!-- PLAYER (YOU) -->
  {#if id === $playerCore?.carriedBy}
    <Model scale={0.6} url="/models/CharacterSkeletonMeshAnims_02.glb">
      <Group slot="cores">
        {#each getCores(id) as [coreId, coreEntity], i (coreId)}
          <Core {i} id={coreId} entity={coreEntity} />
        {/each}
      </Group>
    </Model>

    <Camera />
  {/if}

  <!-- SOMETHING ELSE -->
  <!-- WALL -->
  {#if isWall(id)}
    <Model url="/models/WallSkeletonMesh_01.glb">
      {#each getCores(id) as [coreId, coreEntity], i (coreId)}
        <Core {i} id={coreId} entity={coreEntity} />
      {/each}
    </Model>
  {/if}
</Group>
