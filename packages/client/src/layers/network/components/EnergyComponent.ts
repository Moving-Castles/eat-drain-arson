import type { World } from "@latticexyz/recs";
import { defineComponent, Type } from "@latticexyz/recs";

export function defineEnergyComponent(world: World) {
  return defineComponent(
    world,
    {
      value: Type.Number,
    },
    {
      id: "Energy",
      metadata: { contractId: "component.Energy" },
    }
  );
}
