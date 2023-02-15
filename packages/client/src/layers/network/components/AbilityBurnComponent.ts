import type { World } from "@latticexyz/recs";
import { defineComponent, Type } from "@latticexyz/recs";

export function defineAbilityBurnComponent(world: World) {
  return defineComponent(
    world,
    {
      value: Type.Boolean,
    },
    {
      id: "AbilityBurn",
      metadata: { contractId: "component.AbilityBurn" },
    }
  );
}
