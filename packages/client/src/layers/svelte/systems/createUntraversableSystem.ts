import type { ComponentUpdate } from "@latticexyz/recs";
import type { EntityType } from "../modules/entities";
import type { NetworkLayer } from "../../network";
import { defineComponentSystem } from "@latticexyz/recs";
import { entities, indexToID } from "../modules/entities";

export function createUntraversableSystem(network: NetworkLayer) {
  const {
    world,
    components: { Untraversable },
  } = network;

  defineComponentSystem(world, Untraversable, (update) => {
    console.log("==> Untraversable system: ", update);
    const untraversable = update.value[0]?.value;
    entities.update((value) => {
      if (!value[indexToID(update.entity)]) value[indexToID(update.entity)] = {};
      value[indexToID(update.entity)].untraversable = untraversable;
      return value;
    });
  });
}
