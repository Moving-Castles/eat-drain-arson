import type { World } from "@latticexyz/recs";
import { defineComponent, Type } from "@latticexyz/recs";

export function defineUntraversableComponent(world: World) {
  return defineComponent(
    world,
    {
      value: Type.Boolean,
    },
    {
      id: "Untraversable",
      metadata: { contractId: "component.Untraversable" },
    }
  );
}
