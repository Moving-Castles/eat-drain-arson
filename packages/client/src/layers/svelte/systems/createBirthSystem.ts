import type { ComponentUpdate } from "@latticexyz/recs";
import type { EntityType } from "../modules/entities";
import type { NetworkLayer } from "../../network";
import { defineComponentSystem } from "@latticexyz/recs";
import { entities, indexToID } from "../modules/entities";

export function createBirthSystem(network: NetworkLayer) {
  const {
    world,
    components: { Birth },
  } = network;

  defineComponentSystem(world, Birth, (update) => {
    console.log("==> Birth system: ", update);
    const birth = update.value[0]?.value;
    entities.update((value) => {
      if (!value[indexToID(update.entity)]) value[indexToID(update.entity)] = {};
      value[indexToID(update.entity)].birth = birth;
      return value;
    });
  });
}
