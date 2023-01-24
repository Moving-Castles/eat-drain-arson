import type { NetworkLayer } from "../../network";
import { defineComponentSystem } from "@latticexyz/recs";
import { entities, indexToID } from "../modules/entities";

export function createCoreSystem(network: NetworkLayer) {
  const {
    world,
    components: { Core },
  } = network;

  defineComponentSystem(world, Core, (update) => {
    console.log("==> Core system: ", update);
    const core = update.value[0]?.value;
    entities.update((value) => {
      if (!value[indexToID(update.entity)]) value[indexToID(update.entity)] = {};
      value[indexToID(update.entity)].core = core;
      return value;
    });
  });
}
