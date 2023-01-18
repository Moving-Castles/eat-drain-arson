import type { ComponentUpdate } from "@latticexyz/recs";
import type { EntityType } from "../modules/entities";
import type { NetworkLayer } from "../../network";
import { defineComponentSystem } from "@latticexyz/recs";
import { entities, indexToID } from "../modules/entities";

export function createPortableSystem(network: NetworkLayer) {
  const {
    world,
    components: { Portable },
  } = network;

  defineComponentSystem(world, Portable, (update) => {
    console.log("==> Portable system: ", update);
    const portable = update.value[0]?.value;
    entities.update((value) => {
      if (!value[indexToID(update.entity)]) value[indexToID(update.entity)] = {};
      value[indexToID(update.entity)].portable = portable;
      return value;
    });
  });
}
