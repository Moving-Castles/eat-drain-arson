import { defineComponentSystem } from "@latticexyz/recs";
import type { NetworkLayer } from "../../network";
import { entities, indexToID } from "../modules/entities";

export function createDeathSystem(network: NetworkLayer) {
  const {
    world,
    components: { Death },
  } = network;

  defineComponentSystem(world, Death, (update) => {
    console.log("==> Death system: ", update);
    const death = update.value[0]?.value;

    entities.update((value) => {
      if (!value[indexToID(update.entity)]) value[indexToID(update.entity)] = {};
      value[indexToID(update.entity)].death = death;
      return value;
    });
  });
}
