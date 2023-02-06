import type { World } from "@latticexyz/recs";
import { defineComponent, Type } from "@latticexyz/recs";

export function defineGameConfigComponent(world: World) {
  return defineComponent(
    world,
    {
      worldHeight: Type.Number,
      worldWidth: Type.Number,
      initialEnergy: Type.Number,
      matterPerTile: Type.Number,
      defaultCarryingCapacity: Type.Number,
      moveCost: Type.Number,
      pickUpCost: Type.Number,
      dropCost: Type.Number,
      giveCost: Type.Number,
      takeCost: Type.Number,
      moveCooldown: Type.Number,
      extractCooldown: Type.Number,
    },
    {
      id: "GameConfig",
      metadata: { contractId: "component.GameConfig" },
    }
  );
}
