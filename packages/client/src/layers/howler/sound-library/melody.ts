import type { SoundAssets } from "../types";

const BASE_VOLUME = 0.4;

export const melody: SoundAssets = {
  digibell: {
    src: "/src/public/sounds/melody/digibell.mp3",
    volume: BASE_VOLUME,
  },
  guitar: {
    src: "/src/public/sounds/melody/guitar.mp3",
    volume: BASE_VOLUME,
  },
  pluckedOne: {
    src: "/src/public/sounds/melody/plucked1.mp3",
    volume: BASE_VOLUME,
  },
  pluckedTwo: {
    src: "/src/public/sounds/melody/plucked2.mp3",
    volume: BASE_VOLUME,
  },
  synth: {
    src: "/src/public/sounds/melody/synth.mp3",
    volume: BASE_VOLUME,
  },
};
