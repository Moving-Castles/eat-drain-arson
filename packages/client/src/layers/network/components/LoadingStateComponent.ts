import type { World } from "@latticexyz/recs";
import { defineComponent, Type } from "@latticexyz/recs";

export function defineLoadingStateComponent(world: World) {
  return defineComponent(
    world,
    {
      state: Type.Number,
      msg: Type.String,
      percentage: Type.Number,
    },
    {
      id: "LoadingState",
      metadata: {
        contractId: "component.LoadingState",
      },
    }
  );
}
