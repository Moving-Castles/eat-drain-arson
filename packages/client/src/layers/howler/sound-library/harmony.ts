import type { SoundAssets } from "../types";

const BASE_VOLUME = 0.4;

export const harmony: SoundAssets = {
  bass: {
    src: "/src/public/sounds/harmony/bass.mp3",
    volume: BASE_VOLUME,
  },
  harmonyPad: {
    src: "/src/public/sounds/harmony/harmony-pad.mp3",
    volume: BASE_VOLUME,
  },
  mysteryPad: {
    src: "/src/public/sounds/harmony/mystery-pad.mp3",
    volume: BASE_VOLUME,
  },
  organLoop: {
    src: "/src/public/sounds/harmony/organ-loop.mp3",
    volume: BASE_VOLUME,
  },
  tonalDroneLoop: {
    src: "/src/public/sounds/harmony/tonal-drone-loop.mp3",
    volume: BASE_VOLUME,
  },
};
