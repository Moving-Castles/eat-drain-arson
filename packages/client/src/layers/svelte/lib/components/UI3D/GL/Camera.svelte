<script>
  import { T, TransformableObject } from "@threlte/core";
  import { playerBaseEntity } from "../../../../modules/player";
  let cam;
</script>

<T.OrthographicCamera
  zoom={80}
  near={1}
  far={2000}
  let:ref={cam}
  position.x={10}
  position.z={10}
  position.y={8}
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
