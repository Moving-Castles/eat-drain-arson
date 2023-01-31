<script lang="ts">
  import { InstancedMesh, Instance, useTexture } from "@threlte/core";
  import { DEG2RAD } from "three/src/math/MathUtils";
  import { Vector2, Vector3, DoubleSide, MeshBasicMaterial, PlaneGeometry, Color } from "three";

  const map = useTexture("/images/tilesets/verboten.png");
  map.wrapS = 1;
  map.wrapT = 1;

  let showActions = false;
  const rotation = new Vector3(DEG2RAD * 90, 0, 0);

  const toggleActions = () => {
    showActions = !showActions;
  };

  const positions = [
    new Vector3(-1, 0, -1),
    new Vector3(-1, 0, 0),
    new Vector3(-1, 0, 1),
    new Vector3(0, 0, -1),
    new Vector3(0, 0, 0),
    new Vector3(0, 0, 1),
    new Vector3(1, 0, -1),
    new Vector3(1, 0, 0),
    new Vector3(1, 0, 1),
  ];
</script>

<InstancedMesh
  material={new MeshBasicMaterial({
    map,
    wireframe: false,
    side: DoubleSide,
  })}
  geometry={new PlaneGeometry(10, 10)}
>
  {#each positions as pos}
    <Instance {rotation} position={{ x: pos.x * 10, z: pos.z * 10, y: -0.01 }} />
  {/each}
</InstancedMesh>

<!-- <Mesh
  {rotation}
  userData={{ tile }}
  position={{ x, y, z }}
  interactive
  on:click={toggleActions}
  receiveShadow
  material={new MeshBasicMaterial({
    map,
    wireframe: false,
    side: DoubleSide,
  })}
  geometry={new PlaneGeometry(3, 10)}
>
  {#if showActions}
    <TileActions on:close={toggleActions} {tile} />
  {/if}
</Mesh> -->
