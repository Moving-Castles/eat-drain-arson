import type { Texture } from "three";
import { writable } from "svelte/store";

export const textureSources = {
  empty: "/images/tiles/overlays/xs/empty.png",
  corpse: "/images/tiles/overlays/xs/corpse.png",
  "mined-1": "/images/tiles/overlays/xs/mined-1.png",
  "mined-2": "/images/tiles/overlays/xs/mined-2.png",
  "mined-3": "/images/tiles/overlays/xs/mined-3.png",
  map: "/images/tiles/overlays/xs/map.png",
  "dust-1": "/images/tiles/dust/xs/1.png",
  "dust-2": "/images/tiles/dust/xs/2.png",
  "dust-3": "/images/tiles/dust/xs/3.png",
  "dust-4": "/images/tiles/dust/xs/4.png",
  "debris-1": "/images/tiles/debris/xs/1.png",
  "debris-2": "/images/tiles/debris/xs/2.png",
  "debris-3": "/images/tiles/debris/xs/3.png",
  "debris-4": "/images/tiles/debris/xs/4.png",
  "ruins-1": "/images/tiles/ruins/xs/1.png",
  "ruins-2": "/images/tiles/ruins/xs/2.png",
  "ruins-3": "/images/tiles/ruins/xs/3.png",
  "ruins-4": "/images/tiles/ruins/xs/4.png",
  "mask-0": "/images/masks/xs/0.png",
  "mask-1": "/images/masks/xs/1.png",
  "mask-2": "/images/masks/xs/2.png",
  "mask-3": "/images/masks/xs/3.png",
};
export const textures = writable({} as Texture[]);
