import type { Coord } from "@latticexyz/utils";
import type { Entity } from "../../../modules/entities";
import type { Perlin } from "@latticexyz/noise";
import { seedToMaskTileOverlay } from "../../../utils/name";
import { EntityType } from "../../../modules/entities";
import { player } from "../../../modules/player";
import { TerrainCategory } from "../../../utils/space";
import { createPerlin } from "@latticexyz/noise";
import { checkForType } from "../../../operations/utils";
import { fireStatusClass } from "../UIFires/index";
import { get } from "svelte/store";

let perlin: Perlin;

export interface GridTile {
  direction: string;
  transformation: Coord;
  coordinates: Coord;
  perlinFactor: number;
  terrain: TerrainCategory;
  resource: number;
  fire?: Entity | undefined;
  other?: Entity | undefined;
  corpse?: Entity | undefined;
  mined?: Entity | undefined;
}

// In order from low to high
export enum TileOverlays {
  // Gathering
  Empty = "empty",
  Depleted = "mined-3",
  Extracted = "mined-2",
  Dug = "mined-1",
  // Masks
  Thief = "mask-0",
  Scavenger = "mask-1",
  Hunter = "mask-2",
  Mage = "mask-3",
  // Players
  Other = "mask other",
  Player = "mask player",
  CorpseMask = "mask corpse",
  Corpse = "corpse",
  // Fire
  FireOff = "fire-off",
  FireOn = "fire-on",
}

// In order from low to high
export enum TileTextureKeys {
  // Gathering
  Empty = "empty",
  Depleted = "mined-3",
  Extracted = "mined-2",
  Dug = "mined-1",
  // Masks
  Thief = "mask-0",
  Scavenger = "mask-1",
  Hunter = "mask-2",
  Mage = "mask-3",
  // Players
  Other = "other",
  Player = "player",
  CorpseMask = "corpse",
  Corpse = "corpse",
  // Fire
  FireOff = "fire-off",
  FireOn = "fire-on",
}

export function perlinToTerrainCategory(p: number) {
  if (p < 0.4) return TerrainCategory.Dust;
  if (p < 0.6) return TerrainCategory.Debris;
  return TerrainCategory.Ruins;
}

export function initGrid(unit: number) {
  let grid = [] as GridTile[];
  for (let y = 0; y <= unit - 1; y++) {
    for (let x = 0; x <= unit - 1; x++) {
      const yVal = y - Math.floor(unit / 2);
      const xVal = x - Math.floor(unit / 2);

      const newGridTile: GridTile = {
        direction: ".",
        transformation: { x: xVal, y: yVal },
        coordinates: { x: 0, y: 0 },
        perlinFactor: 0,
        terrain: TerrainCategory.Dust,
        resource: 100,
      };
      grid = [...grid, newGridTile];
    }
  }

  return grid;
}

export async function updateGrid(centerPosition: Coord, grid: GridTile[]) {
  perlin = await createPerlin();

  for (let i = 0; i < grid.length; i++) {
    grid[i].coordinates.x = (centerPosition?.x || 0) + grid[i].transformation.x;
    grid[i].coordinates.y = (centerPosition?.y || 0) + grid[i].transformation.y;
    grid[i].perlinFactor = perlin(grid[i].coordinates.x, grid[i].coordinates.y, 0, 20);
    grid[i].terrain = perlinToTerrainCategory(grid[i].perlinFactor);
    grid[i].fire = checkForType(grid[i].coordinates, EntityType.Fire);
    grid[i].other =
      checkForType(grid[i].coordinates, EntityType.Player) || checkForType(grid[i].coordinates, EntityType.Corpse);
    grid[i].corpse = checkForType(grid[i].coordinates, EntityType.Corpse);
    grid[i].mined = checkForType(grid[i].coordinates, EntityType.Terrain);
    grid[i].resource = grid[i].mined == undefined ? 100 : grid[i].mined.resource;
  }

  grid = [...grid];
  return grid;
}

export function isPlayerTile(tile: GridTile) {
  return tile.transformation.x == 0 && tile.transformation.y == 0;
}

/**
 * Conditions for the 2D maps' tiles
 */
export const conditions = [
  // Mined
  (tile: GridTile) => (tile.resource == 0 ? TileOverlays.Empty : null),
  (tile: GridTile) => (tile.resource < 33 && tile.resource > 0 ? TileOverlays.Depleted : null),
  (tile: GridTile) => (tile.resource < 66 && tile.resource >= 33 ? TileOverlays.Extracted : null),
  (tile: GridTile) => (tile.resource < 100 && tile.resource >= 66 ? TileOverlays.Dug : null),
  // Other player
  (tile: GridTile) =>
    tile.other !== undefined ? `${TileOverlays.Other} ${seedToMaskTileOverlay(tile.other?.seed || 0)}` : null,
  // Player
  (tile: GridTile) => {
    if (isPlayerTile(tile)) {
      return `${TileOverlays.Player} ${seedToMaskTileOverlay(get(player).seed || 0)} ${
        get(player).entityType == EntityType.Corpse ? TileOverlays.CorpseMask : ""
      }`;
    }
  },
  // Player corpse
  (tile: GridTile) => {
    if (tile.transformation.x == 0 && tile.transformation.y == 0 && get(player).entityType == EntityType.Corpse) {
      return TileOverlays.Corpse;
    }
  },
  // Corpse
  (tile: GridTile) => (tile.corpse !== undefined ? TileOverlays.Corpse : null),
  // Fire
  (tile: GridTile) => (tile.fire !== undefined ? fireStatusClass(tile.fire) : null),
];

/**
 * Conditions for the tiles' 3D textures
 */
export const textureConditions = [
  // Mined
  (tile: GridTile) => (tile.resource == 0 ? TileTextureKeys.Empty : null),
  (tile: GridTile) => (tile.resource < 33 && tile.resource > 0 ? TileTextureKeys.Depleted : null),
  (tile: GridTile) => (tile.resource < 66 && tile.resource >= 33 ? TileTextureKeys.Extracted : null),
  (tile: GridTile) => (tile.resource < 100 && tile.resource >= 66 ? TileTextureKeys.Dug : null),
  // Other player
  (tile: GridTile) => (tile.other !== undefined ? seedToMaskTileOverlay(tile.other?.seed || 0) : null),
  // Player
  (tile: GridTile) => {
    if (isPlayerTile(tile)) {
      return seedToMaskTileOverlay(get(player).seed || 0);
    }
  },
  // Player corpse
  (tile: GridTile) => {
    if (tile.transformation.x == 0 && tile.transformation.y == 0 && get(player).entityType == EntityType.Corpse) {
      return TileTextureKeys.Corpse;
    }
  },
  // Corpse
  (tile: GridTile) => (tile.corpse !== undefined ? TileTextureKeys.Corpse : null),
  // Fire
  (tile: GridTile) => (tile.fire !== undefined ? fireStatusClass(tile.fire) : null),
];
