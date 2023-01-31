import type { NetworkLayer } from "../../network";
import { defineComponentSystem } from "@latticexyz/recs";
import { entities, indexToID } from "../modules/entities";

export function createAbilityConsumeSystem(network: NetworkLayer) {
  const {
    world,
    components: { AbilityConsume },
  } = network;

  defineComponentSystem(world, AbilityConsume, (update) => {
    console.log("==> AbilityConsume system: ", update);
    const abilityConsume = update.value[0]?.value;
    entities.update((value) => {
      if (!value[indexToID(update.entity)]) value[indexToID(update.entity)] = {};
      value[indexToID(update.entity)].abilityConsume = abilityConsume;
      return value;
    });
  });
}
