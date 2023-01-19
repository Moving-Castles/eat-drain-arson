import type { NetworkLayer } from "../../network";
import { defineComponentSystem } from "@latticexyz/recs";
import { entities, indexToID } from "../modules/entities";

export function createCarriedBySystem(network: NetworkLayer) {
  const {
    world,
    components: { CarriedBy },
  } = network;

  defineComponentSystem(world, CarriedBy, (update) => {
    console.log("==> CarriedBy system: ", update);
    const carriedBy = update.value[0]?.value;
    entities.update((value) => {
      if (!value[indexToID(update.entity)]) value[indexToID(update.entity)] = {};
      value[indexToID(update.entity)].carriedBy = carriedBy;
      return value;
    });
  });
}
