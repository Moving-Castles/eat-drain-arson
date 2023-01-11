<script lang="ts">
  import type { GridTile } from "../UIGridMap/index";
  import { textureConditions } from "../UIGridMap/index";
  import { TerrainCategory } from "../../../utils/space";
  import { T } from "@threlte/core";
  import { textures } from "./index";
  import { DEG2RAD } from "three/src/math/MathUtils";
  import { DoubleSide } from "three";
  import { Text } from "@threlte/extras";
  import { DEV } from "../../../utils/ui";

  export let tile: GridTile;

  let map;
  let tileTextureKeys = [];

  const textureKey = () => {
    const randomAddition = Math.floor(Math.random() * 4);
    switch (tile.terrain) {
      case TerrainCategory.Dust:
        return "dust-" + (((tile.coordinates.x + tile.coordinates.y + randomAddition) % 4) + 1);
      case TerrainCategory.Debris:
        return "debris-" + (((tile.coordinates.x + tile.coordinates.y + randomAddition) % 4) + 1);
      case TerrainCategory.Ruins:
        return "ruins-" + (((tile.coordinates.x + tile.coordinates.y + randomAddition) % 4) + 1);
    }
  };

  $: {
    tileTextureKeys = textureConditions.map((c) => c(tile)).filter((o) => !!o);
  }

  map = $textures[textureKey()];
</script>

<T.Group
  rotation.y={0}
  rotation.x={DEG2RAD * -90}
  rotation.z={DEG2RAD * -90}
  position.x={tile.transformation.x}
  position.z={tile.transformation.y}
>
  <T.Mesh receiveShadow>
    <T.PlaneGeometry args={[1, 1]} />
    <!-- Base texture -->
    <T.MeshBasicMaterial wireframe={DEV} side={DoubleSide} {map} />
  </T.Mesh>

  {#each tileTextureKeys as key, i (key + i)}
    <T.Group position.z={(i + 1) * 0.6}>
      <T.Mesh receiveShadow>
        <T.PlaneGeometry args={[1, 1]} />
        <!-- Base texture -->
        <T.MeshBasicMaterial wireframe={DEV} side={DoubleSide} map={$textures[key]} />
      </T.Mesh>
    </T.Group>
  {/each}

  <T.Group rotation.z={DEG2RAD * -45 - DEG2RAD * 180}>
    {#if DEV}
      <Text anchorX="center" anchorY="center" text="x: {tile.coordinates.x} / y: {tile.coordinates.y}" />
    {/if}
  </T.Group>
</T.Group>
