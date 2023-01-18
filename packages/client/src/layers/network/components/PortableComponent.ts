import type { World } from "@latticexyz/recs";
import { defineComponent, Type } from "@latticexyz/recs";

export function definePortableComponent(world: World) {
  return defineComponent(
    world,
    {
      value: Type.Boolean,
    },
    {
      id: "Portable",
      metadata: { contractId: "component.Portable" },
    }
  );
}
