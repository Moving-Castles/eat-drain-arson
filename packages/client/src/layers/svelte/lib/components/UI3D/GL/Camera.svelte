<script>
  import { T, TransformableObject } from "@threlte/core";
  import { useParent } from "@threlte/core";
  import { PerspectiveCamera } from "three";

  const parent = useParent();

  console.log($parent);

  // Camera focuses on the base entity that is carrying the core
  let cam;
</script>

<!-- <T.OrthographicCamera
  position.x={0}
  position.z={0}
  position.y={10}
  zoom={100}
  near={1}
  far={2000}
  let:ref={cam}
  makeDefault
>
  <TransformableObject object={cam} lookAt={{ x: 0, y: 0, z: 0 }} />
</T.OrthographicCamera> -->

<T.PerspectiveCamera
  fov={1}
  position.x={0}
  position.z={150}
  position.y={150}
  zoom={1}
  near={1}
  far={2000}
  let:ref={cam}
  makeDefault
>
  {#if $parent}
    <TransformableObject
      object={cam}
      lookAt={{ x: $parent.position.x, y: $parent.position.y, z: $parent.position.z }}
    />
  {/if}
</T.PerspectiveCamera>
