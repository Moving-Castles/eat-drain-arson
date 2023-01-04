import { defineComponentSystem } from "@latticexyz/recs";
import type { NetworkLayer } from "../../network";
import { entities, indexToID } from "../modules/entities";
import { addToLog, EventCategory } from "../modules/narrator";

export function createCannibalSystem(network: NetworkLayer) {
  const {
    world,
    components: { Cannibal },
  } = network;

  defineComponentSystem(world, Cannibal, (update) => {
    console.log("==> Cannibal system: ", update);
    const cannibal: string[] = update.value[0]?.value;
    entities.update((value) => {
      if (!value[indexToID(update.entity)]) value[indexToID(update.entity)] = {};
      value[indexToID(update.entity)].cannibal = cannibal;
      return value;
    });

    addToLog(update, EventCategory.Cannibalism);
  });
}
