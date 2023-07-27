import type { World } from "@latticexyz/recs";
import { defineComponent, Type } from "@latticexyz/recs";

export function definePositionComponent(world: World) {
  return defineComponent(
    world,
    {
      x: Type.Number,
      y: Type.Number,
    },
    {
      id: "Position",
      metadata: { contractId: "component.Position" },
    }
  );
}
