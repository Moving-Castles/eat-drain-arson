import type { World } from "@latticexyz/recs";
import { defineComponent, Type } from "@latticexyz/recs";

export function defineInventoryComponent(world: World) {
  return defineComponent(
    world,
    {
      value: Type.StringArray,
    },
    {
      id: "Inventory",
      metadata: {
        contractId: "component.Inventory",
      },
    }
  );
}
