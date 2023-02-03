<script lang="ts">
  // GAME
  import { addressToColor } from "../../../../../utils/ui";
  import { playerAddress } from "../../../../../modules/player";
  import type { Entity } from "../../../../../modules/entities";

  // GL
  import { Vector3 } from "three";
  import { DEG2RAD } from "three/src/math/MathUtils";
  import CoreHead from "./CoreHead.svelte";

  export let id: string;
  export let entity: Entity;
  export let i: number;

  console.log("hello from corehead", id);
  const position = new Vector3(0.5, 0.15 + 0.2 * i, 0.5);
  let scale = 1;
</script>

<CoreHead {position} scale={$playerAddress === id ? scale : 1} {id} />
