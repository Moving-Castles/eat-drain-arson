import type { Texture } from "three";
import { writable } from "svelte/store";

export const textureSources = {
  empty: "/src/public/images/tiles/overlays/xs/empty.png",
  corpse: "/src/public/images/tiles/overlays/xs/corpse.png",
  "mined-1": "/src/public/images/tiles/overlays/xs/mined-1.png",
  "mined-2": "/src/public/images/tiles/overlays/xs/mined-2.png",
  "mined-3": "/src/public/images/tiles/overlays/xs/mined-3.png",
  map: "/src/public/images/tiles/overlays/xs/map.png",
  "dust-1": "/src/public/images/tiles/dust/xs/1.png",
  "dust-2": "/src/public/images/tiles/dust/xs/2.png",
  "dust-3": "/src/public/images/tiles/dust/xs/3.png",
  "dust-4": "/src/public/images/tiles/dust/xs/4.png",
  "debris-1": "/src/public/images/tiles/debris/xs/1.png",
  "debris-2": "/src/public/images/tiles/debris/xs/2.png",
  "debris-3": "/src/public/images/tiles/debris/xs/3.png",
  "debris-4": "/src/public/images/tiles/debris/xs/4.png",
  "ruins-1": "/src/public/images/tiles/ruins/xs/1.png",
  "ruins-2": "/src/public/images/tiles/ruins/xs/2.png",
  "ruins-3": "/src/public/images/tiles/ruins/xs/3.png",
  "ruins-4": "/src/public/images/tiles/ruins/xs/4.png",
};
export const textures = writable({} as Texture[]);
