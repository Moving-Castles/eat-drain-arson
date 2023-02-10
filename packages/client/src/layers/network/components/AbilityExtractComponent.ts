import type { World } from "@latticexyz/recs";
import { defineComponent, Type } from "@latticexyz/recs";

export function defineAbilityExtractComponent(world: World) {
  return defineComponent(
    world,
    {
      value: Type.Boolean,
    },
    {
      id: "AbilityExtract",
      metadata: { contractId: "component.AbilityExtract" },
    }
  );
}
