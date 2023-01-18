import type { ComponentUpdate } from "@latticexyz/recs";
import type { EntityType } from "../modules/entities";
import type { NetworkLayer } from "../../network";
import { defineComponentSystem } from "@latticexyz/recs";
import { entities, indexToID } from "../modules/entities";

export function createControlSystem(network: NetworkLayer) {
  const {
    world,
    components: { Control },
  } = network;

  defineComponentSystem(world, Control, (update) => {
    console.log("==> Control system: ", update);
    const control = update.value[0]?.value;
    entities.update((value) => {
      if (!value[indexToID(update.entity)]) value[indexToID(update.entity)] = {};
      value[indexToID(update.entity)].control = control;
      return value;
    });
  });
}
