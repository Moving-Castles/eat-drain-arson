import type { World } from "@latticexyz/recs";
import { defineComponent, Type } from "@latticexyz/recs";

export function defineReadyBlockComponent(world: World) {
  return defineComponent(
    world,
    {
      value: Type.Number,
    },
    {
      id: "ReadyBlock",
      metadata: { contractId: "component.ReadyBlock" },
    }
  );
}
