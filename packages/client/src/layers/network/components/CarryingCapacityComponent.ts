import type { World } from "@latticexyz/recs";
import { defineComponent, Type } from "@latticexyz/recs";

export function defineCarryingCapacityComponent(world: World) {
  return defineComponent(
    world,
    {
      value: Type.Number,
    },
    {
      id: "CarryingCapacity",
      metadata: { contractId: "component.CarryingCapacity" },
    }
  );
}
