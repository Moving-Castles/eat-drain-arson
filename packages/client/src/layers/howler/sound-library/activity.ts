import type { SoundAssets } from "../types";

const BASE_VOLUME = 0.7;

export const activity: SoundAssets = {
  digging: {
    src: "/src/public/sounds/activity/digging.mp3",
    volume: BASE_VOLUME,
  },
  eating: {
    src: "/src/public/sounds/activity/eating.mp3",
    volume: BASE_VOLUME,
  },
  idle: {
    src: "/src/public/sounds/activity/idle.mp3",
    volume: 0.3,
  },
  walking: {
    src: "/src/public/sounds/activity/walking.mp3",
    volume: BASE_VOLUME,
  },
};
