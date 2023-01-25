<script lang="ts">
  import type { GridTile } from "../../UIGridMap";
  import { textureConditions } from "../../UIGridMap/index";
  import { TerrainCategory } from "../../../../utils/space";
  import { T, Mesh } from "@threlte/core";
  import { textures } from "../index";
  import { DEG2RAD } from "three/src/math/MathUtils";
  import { Vector3, DoubleSide, MeshBasicMaterial, PlaneGeometry, Color } from "three";
  import TileActions from "./TileActions.svelte";
  import { Text } from "@threlte/extras";
  import { DEV } from "../../../../utils/ui";

  export let tile: GridTile;

  let map;
  let showActions = false;
  let tileMesh;
  let tileTextureKeys = [];

  const y = 0;
  const {
    x,
    y: z, // y becomes z in 3D space
  } = tile.coordinates;
  const rotation = new Vector3(DEG2RAD * 90, 0, 0);

  const textureKey = () => {
    // const randomAddition = Math.floor(Math.random() * 4);
    switch (tile.terrain) {
      case TerrainCategory.Dust:
        return "dust-" + (((tile.coordinates.x + tile.coordinates.y) % 4) + 1);
      case TerrainCategory.Debris:
        return "debris-" + (((tile.coordinates.x + tile.coordinates.y) % 4) + 1);
      case TerrainCategory.Ruins:
        return "ruins-" + (((tile.coordinates.x + tile.coordinates.y) % 4) + 1);
    }
  };

  const toggleActions = () => {
    showActions = !showActions;
  };

  $: {
    tileTextureKeys = textureConditions.map((c) => c(tile)).filter((o) => !!o);
  }

  map = $textures[textureKey()];

  console.log("tile", map);
</script>

<Mesh
  {rotation}
  userData={{ tile }}
  position={{ x, y, z }}
  interactive
  on:click={toggleActions}
  receiveShadow
  material={new MeshBasicMaterial({
    wireframe: true,
    side: DoubleSide,
    color: new Color(tile.perlinFactor * 255, tile.perlinFactor * 255, tile.perlinFactor * 255),
  })}
  geometry={new PlaneGeometry(1, 1)}
>
  {#if showActions}
    <TileActions on:close={toggleActions} {tile} />
  {/if}
</Mesh>
