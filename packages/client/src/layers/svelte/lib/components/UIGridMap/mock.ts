import type { GridTile } from "./index";
import type { Fire, Player } from "../../../modules/entities";
import { EntityType } from "../../../modules/entities";

const mockHex = (min = 0, range = 666) => Math.floor(Math.random() * range).toString(16);

export const generateMockGrid = (grid: GridTile[], playersAmount: number) => {
  for (let i = 0; i < playersAmount; i++) {
    const randomIndex = Math.floor(Math.random() * grid.length);
    const value = grid[randomIndex];

    const newPlayer = {
      entityType: EntityType.Player,
      position: value.coordinates,
      coolDownBlock: 0,
      energy: 100,
      resource: 100,
      seed: mockHex(),
      birth: mockHex(1000),
      death: mockHex(1666),
    };
    value.other = newPlayer;
    grid[randomIndex] = value;
  }

  return grid;
};
