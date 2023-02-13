import type { World } from "@latticexyz/recs";
import { defineComponent, Type } from "@latticexyz/recs";

export function defineBurnBlockComponent(world: World) {
  return defineComponent(
    world,
    {
      value: Type.Number,
    },
    {
      id: "BurnBlock",
      metadata: { contractId: "component.BurnBlock" },
    }
  );
}
