<script>
  import { T, TransformableObject } from "@threlte/core";
  import { useParent, OrbitControls } from "@threlte/core";
  import { spring } from "svelte/motion";

  const parent = useParent();
  let zoom = spring(1, { stiffness: 0.2, damping: 0.9 });

  const onKeyPress = ({ key }) => {
    if (key === "=") {
      $zoom *= 2;
    }
    if (key === "-") {
      $zoom /= 2;
    }
  };

  let pan = true;

  // Camera focuses on the base entity that is carrying the core
  let cam;
</script>

<svelte:window on:keypress={onKeyPress} />

<T.PerspectiveCamera
  fov={1}
  position.x={150}
  position.z={150}
  position.y={150}
  zoom={$zoom}
  near={100}
  far={1000}
  let:ref={cam}
  makeDefault
>
  {#if $parent}
    <TransformableObject
      object={cam}
      lookAt={{ x: $parent.position.x, y: $parent.position.y - 0.4, z: $parent.position.z }}
    />
  {/if}

  {#if pan}
    <OrbitControls enableDamping />
  {/if}
</T.PerspectiveCamera>
