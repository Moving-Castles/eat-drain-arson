<script>
  import { T, TransformableObject } from "@threlte/core";

  // Camera focuses on the base entity that is carrying the core
  let cam;
</script>

<T.OrthographicCamera
  zoom={200}
  near={1}
  far={2000}
  let:ref={cam}
  position.x={10}
  position.z={10}
  position.y={10}
  makeDefault
>
  <TransformableObject
    object={cam}
    lookAt={{
      y: 0,
      x: 0,
      z: 0,
    }}
  />
</T.OrthographicCamera>
