import { binaryProgress, activeOperation } from "./index";
import { derived } from "svelte/store";
import { player } from "../../modules/player";
import { directToLog } from "../../modules/narrator";
import { sequencerState } from "../../modules/sequencer";
import { directionStringToTransformation } from "../../utils/space";

export const playerPosition = derived([binaryProgress, activeOperation, player], ([$b, $a, $p]) => {
  directToLog($b);
  return $p.position;
});
