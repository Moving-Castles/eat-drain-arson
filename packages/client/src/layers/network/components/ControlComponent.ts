import type { World } from "@latticexyz/recs";
import { defineComponent, Type } from "@latticexyz/recs";

export function defineControlComponent(world: World) {
  return defineComponent(
    world,
    {
      value: Type.String,
    },
    {
      id: "Control",
      metadata: { contractId: "component.Control" },
    }
  );
}
