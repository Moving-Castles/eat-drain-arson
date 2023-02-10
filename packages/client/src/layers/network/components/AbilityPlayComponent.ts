import type { World } from "@latticexyz/recs";
import { defineComponent, Type } from "@latticexyz/recs";

export function defineAbilityPlayComponent(world: World) {
  return defineComponent(
    world,
    {
      value: Type.Boolean,
    },
    {
      id: "AbilityPlay",
      metadata: { contractId: "component.AbilityPlay" },
    }
  );
}
