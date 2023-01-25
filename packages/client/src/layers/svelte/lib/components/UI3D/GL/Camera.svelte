<script>
  import { T, TransformableObject } from "@threlte/core";
  import { playerPositionX as x, playerPositionY as y } from "../../../../modules/player";
  let cam;

  $: console.log($x, $y);
</script>

<T.OrthographicCamera
  zoom={40}
  near={1}
  far={2000}
  let:ref={cam}
  position.x={$x}
  position.z={$y}
  position.y={10}
  makeDefault
>
  <TransformableObject
    object={cam}
    lookAt={{
      y: 0,
      x: $x,
      z: $y,
    }}
  />
</T.OrthographicCamera>
