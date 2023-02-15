import type { World } from "@latticexyz/recs";
import { defineComponent, Type } from "@latticexyz/recs";

export function defineCommitComponent(world: World) {
  return defineComponent(
    world,
    {
      value: Type.Number,
    },
    {
      id: "Commit",
      metadata: { contractId: "component.Commit" },
    }
  );
}
