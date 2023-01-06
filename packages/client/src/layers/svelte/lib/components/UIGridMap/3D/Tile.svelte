<script lang="ts">
  import type { GridTile } from "../index";
  import { TerrainCategory } from "../../../../utils/space";
  import { T, useTexture } from "@threlte/core";
  import { Vector3 } from "three";
  import { textures } from "./index";
  import { onMount } from "svelte";

  let map;
  export let tile: GridTile;

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

  console.log(textureKey());

  map = $textures[textureKey()];
</script>

<T.Mesh position.x={tile.transformation.x} position.y={tile.transformation.y}>
  <T.PlaneGeometry args={[1, 1]} />
  <T.MeshStandardMaterial {map} />
</T.Mesh>
