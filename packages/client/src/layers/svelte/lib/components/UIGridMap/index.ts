import type { Coord } from "@latticexyz/utils";
import type { Entity } from "../../../modules/entities";
import type { Perlin } from "@latticexyz/noise";
import { EntityCategory } from "../../../modules/entities";
import { TerrainCategory } from "../../../utils/space";
import { createPerlin } from "@latticexyz/noise";
import { checkForType } from "../../../operations/utils";

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
    grid[i].fire = checkForType(grid[i].coordinates, EntityCategory.Fire);
    grid[i].other =
      checkForType(grid[i].coordinates, EntityCategory.Player) ||
      checkForType(grid[i].coordinates, EntityCategory.Corpse);
    grid[i].corpse = checkForType(grid[i].coordinates, EntityCategory.Corpse);
    grid[i].mined = checkForType(grid[i].coordinates, EntityCategory.Terrain);
    grid[i].resource = grid[i].mined == undefined ? 100 : grid[i].mined.resource;
  }

  grid = [...grid];
  return grid;
}
