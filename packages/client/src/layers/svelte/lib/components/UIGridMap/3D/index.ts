import type { Texture } from "three";
import { writable } from "svelte/store";

export const textureSources = {
  empty: "/src/public/images/tiles/overlays/empty.png",
  corpse: "/src/public/images/tiles/overlays/corpse.png",
  "mined-1": "/src/public/images/tiles/overlays/mined-1.png",
  "mined-2": "/src/public/images/tiles/overlays/mined-2.png",
  "mined-3": "/src/public/images/tiles/overlays/mined-3.png",
  map: "/src/public/images/tiles/overlays/map.png",
  "dust-1": "/src/public/images/tiles/dust/1.png",
  "dust-2": "/src/public/images/tiles/dust/2.png",
  "dust-3": "/src/public/images/tiles/dust/3.png",
  "dust-4": "/src/public/images/tiles/dust/4.png",
  "debris-1": "/src/public/images/tiles/debris/1.png",
  "debris-2": "/src/public/images/tiles/debris/2.png",
  "debris-3": "/src/public/images/tiles/debris/3.png",
  "debris-4": "/src/public/images/tiles/debris/4.png",
  "ruins-1": "/src/public/images/tiles/ruins/1.png",
  "ruins-2": "/src/public/images/tiles/ruins/2.png",
  "ruins-3": "/src/public/images/tiles/ruins/3.png",
  "ruins-4": "/src/public/images/tiles/ruins/4.png",
};
export const textures = writable([] as Texture[]);
