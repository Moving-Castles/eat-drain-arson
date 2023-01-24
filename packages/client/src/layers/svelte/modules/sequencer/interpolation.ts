import { binaryProgress, activeOperation } from "./index";
import { derived } from "svelte/store";
import { player } from "../../modules/player";
import { directToLog } from "../../modules/narrator";
import { sequencerState } from "../../modules/sequencer";
import { directionStringToTransformation } from "../../utils/space";

export const playerPosition = derived([binaryProgress, activeOperation, player, sequencerState], ([$b, $a, $p, $s]) => {
  if ($p?.position?.x && $p.position?.y) {
    let x = $p.position.x;
    let y = $p.position.y;

    if ($a) {
      if ($a?.operation) {
        const direction = directionStringToTransformation($a?.operation.name);
        console.log(direction);
        if (direction) {
          if ($b !== 1) {
            x += $b * direction.x;
            y += $b * direction.y;

            // HACK
            // PREVENTING THE JUMP IN TIME
            return {
              x,
              y,
            };
          } else {
            // directToLog(`---`)
            // directToLog(`s: ${$s}`)
            // directToLog(`b: ${$b}`)
            // directToLog(`a: ${$a.operation.name} / p: { x: ${x} / y: ${y}}`)
          }
        }
      }
    }
  }

  return undefined;
});
