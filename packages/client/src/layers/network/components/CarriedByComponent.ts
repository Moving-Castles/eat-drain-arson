import type { World } from "@latticexyz/recs";
import { defineComponent, Type } from "@latticexyz/recs";

export function defineCarriedByComponent(world: World) {
  return defineComponent(
    world,
    {
      value: Type.String,
    },
    {
      id: "CarriedBy",
      metadata: { contractId: "component.CarriedBy" },
    }
  );
}
