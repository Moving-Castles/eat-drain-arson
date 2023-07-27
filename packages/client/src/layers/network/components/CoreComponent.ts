import type { World } from "@latticexyz/recs";
import { defineComponent, Type } from "@latticexyz/recs";

export function defineCoreComponent(world: World) {
  return defineComponent(
    world,
    {
      value: Type.Boolean,
    },
    {
      id: "Core",
      metadata: { contractId: "component.Core" },
    }
  );
}
