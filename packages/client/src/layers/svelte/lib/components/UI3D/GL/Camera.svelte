<script>
  import { T, TransformableObject } from "@threlte/core";
  import { useParent } from "@threlte/core";
  import { PerspectiveCamera } from "three";
  import { spring } from "svelte/motion";

  const parent = useParent();

  console.log($parent);
  let zoom = spring(1, { stiffness: 0.2, damping: 0.9 });

  const onKeyPress = ({ key }) => {
    if (key === "=") {
      $zoom *= 2;
    }
    if (key === "-") {
      $zoom /= 2;
    }

    console.log($zoom);
  };

  // Camera focuses on the base entity that is carrying the core
  let cam;
</script>

<svelte:window on:keypress={onKeyPress} />

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
  position.x={150}
  position.z={150}
  position.y={150}
  zoom={$zoom}
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
