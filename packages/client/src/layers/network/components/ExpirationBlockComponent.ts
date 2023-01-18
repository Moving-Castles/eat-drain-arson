import type { World } from "@latticexyz/recs";
import { defineComponent, Type } from "@latticexyz/recs";

export function defineExpirationBlockComponent(world: World) {
  return defineComponent(
    world,
    {
      value: Type.Number,
    },
    {
      id: "ExpirationBlock",
      metadata: { contractId: "component.ExpirationBlock" },
    }
  );
}
