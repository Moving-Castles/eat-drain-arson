import { defineComponentSystem } from "@latticexyz/recs";
import type { NetworkLayer } from "../../network";
import { entities, indexToID } from "../modules/entities";

export function createCarryingCapacitySystem(network: NetworkLayer) {
  const {
    world,
    components: { CarryingCapacity },
  } = network;

  defineComponentSystem(world, CarryingCapacity, (update) => {
    console.log("==> CarryingCapacity system: ", update);
    const carryingCapacity = update.value[0]?.value;
    entities.update((value) => {
      if (!value[indexToID(update.entity)]) value[indexToID(update.entity)] = {};
      value[indexToID(update.entity)].carryingCapacity = carryingCapacity;
      return value;
    });
  });
}
