import type { World } from "@latticexyz/recs";
import { defineComponent, Type } from "@latticexyz/recs";

export function defineStatsComponent(world: World) {
  return defineComponent(
    world,
    {
      traveled: Type.Number,
      gathered: Type.Number,
      burnt: Type.Number,
      eaten: Type.Number,
      played: Type.Number,
    },
    {
      id: "Stats",
      metadata: {
        contractId: "component.Stats",
      },
    }
  );
}
