import { defineComponentSystem } from "@latticexyz/recs";
import { NetworkLayer } from "../../network";
import { entities, indexToID } from "../modules/entities";
import { addToLog, EventCategory } from "../modules/narrator";

export function createResourceSystem(network: NetworkLayer) {
  const {
    world,
    components: { Resource },
  } = network;

  defineComponentSystem(world, Resource, (update) => {
    console.log("==> Resource system: ", update);
    const oldResource = update.value[1]?.value || 0;
    const resource = update.value[0]?.value || 0;
    entities.update((value) => {
      if (!value[indexToID(update.entity)]) value[indexToID(update.entity)] = {};
      value[indexToID(update.entity)].resource = resource;
      return value;
    });

    if (resource > oldResource) {
      addToLog(update, EventCategory.Gather);
    }
  });
}
