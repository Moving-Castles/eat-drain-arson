<script lang="ts">
  import type { GridTile } from "../index";
  import { TerrainCategory } from "../../../utils/space";
  import { T } from "@threlte/core";
  import { textures } from "./index";
  import { DEG2RAD } from "three/src/math/MathUtils";
  import { DoubleSide } from "three";
  import { Text } from "@threlte/extras";
  import { DEV } from "../../../utils/ui";

  export let tile: GridTile;

  let map;

  const textureKey = () => {
    switch (tile.terrain) {
      case TerrainCategory.Dust:
        return "dust-" + (((tile.coordinates.x + tile.coordinates.y) % 4) + 1);
      case TerrainCategory.Debris:
        return "debris-" + (((tile.coordinates.x + tile.coordinates.y) % 4) + 1);
      case TerrainCategory.Ruins:
        return "ruins-" + (((tile.coordinates.x + tile.coordinates.y) % 4) + 1);
    }
  };

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
    <T.MeshStandardMaterial wireframe={DEV} side={DoubleSide} color="#999999" {map} />
  </T.Mesh>

  <T.Group rotation.z={DEG2RAD * -45 - DEG2RAD * 180}>
    {#if DEV}
      <Text anchorX="center" anchorY="center" text="x: {tile.coordinates.x} / y: {tile.coordinates.y}" />
    {/if}
  </T.Group>
</T.Group>
