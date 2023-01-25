import type { Coord } from "@latticexyz/utils";
import type { Texture } from "three";
import { writable } from "svelte/store";

export const textureSources = {
  empty: "/images/tiles/overlays/empty.png",
  corpse: "/images/tiles/overlays/corpse.png",
  "mined-1": "/images/tiles/overlays/mined-1.png",
  "mined-2": "/images/tiles/overlays/mined-2.png",
  "mined-3": "/images/tiles/overlays/mined-3.png",
  map: "/images/tiles/overlays/map.png",
  "dust-1": "/images/tiles/dust/1.png",
  "dust-2": "/images/tiles/dust/2.png",
  "dust-3": "/images/tiles/dust/3.png",
  "dust-4": "/images/tiles/dust/4.png",
  "debris-1": "/images/tiles/debris/1.png",
  "debris-2": "/images/tiles/debris/2.png",
  "debris-3": "/images/tiles/debris/3.png",
  "debris-4": "/images/tiles/debris/4.png",
  "ruins-1": "/images/tiles/ruins/1.png",
  "ruins-2": "/images/tiles/ruins/2.png",
  "ruins-3": "/images/tiles/ruins/3.png",
  "ruins-4": "/images/tiles/ruins/4.png",
  "mask-0": "/images/masks/0.png",
  "mask-1": "/images/masks/1.png",
  "mask-2": "/images/masks/2.png",
  "mask-3": "/images/masks/3.png",
};
export const textures = writable({} as Texture[]);
