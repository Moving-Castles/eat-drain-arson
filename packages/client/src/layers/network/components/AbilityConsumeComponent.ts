import type { World } from "@latticexyz/recs";
import { defineComponent, Type } from "@latticexyz/recs";

export function defineAbilityConsumeComponent(world: World) {
  return defineComponent(
    world,
    {
      value: Type.Boolean,
    },
    {
      id: "Portable",
      metadata: { contractId: "component.AbilityConsume" },
    }
  );
}
