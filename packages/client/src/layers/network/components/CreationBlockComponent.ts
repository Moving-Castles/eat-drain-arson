import type { World } from "@latticexyz/recs";
import { defineComponent, Type } from "@latticexyz/recs";

export function defineCreationBlockComponent(world: World) {
  return defineComponent(
    world,
    {
      value: Type.Number,
    },
    {
      id: "CreationBlock",
      metadata: { contractId: "component.CreationBlock" },
    }
  );
}
