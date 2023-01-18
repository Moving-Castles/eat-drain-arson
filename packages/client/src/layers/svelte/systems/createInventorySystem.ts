import { defineComponentSystem } from "@latticexyz/recs";
import type { NetworkLayer } from "../../network";
import { entities, indexToID } from "../modules/entities";
import { addToLog, EventCategory } from "../modules/narrator";

export function createInventorySystem(network: NetworkLayer) {
  const {
    world,
    components: { Inventory },
  } = network;

  defineComponentSystem(world, Inventory, (update) => {
    console.log("==> Inventory system: ", update);
    const inventory: string[] = update.value[0]?.value;
    entities.update((value) => {
      if (!value[indexToID(update.entity)]) value[indexToID(update.entity)] = {};
      value[indexToID(update.entity)].inventory = inventory;
      return value;
    });
  });
}
