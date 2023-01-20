import { binaryProgress, activeOperation } from "./index";
import { derived } from "svelte/store";
import { player } from "../../modules/player";
import { directionStringToTransformation } from "../../utils/space";

export const playerPosition = derived([binaryProgress, activeOperation, player], ([$b, $a, $p]) => {
  let x = $p?.position?.x || 0;
  let y = $p?.position?.y || 0;

  if ($a) {
    console.log($a);
    if ($a?.operation) {
      const direction = directionStringToTransformation($a?.operation.name);
      if (direction) {
        x += $b * direction.x;
        y += $b * direction.y;
      }
    }
  }

  console.log(x, y);
  return {
    x,
    y,
  };
});
