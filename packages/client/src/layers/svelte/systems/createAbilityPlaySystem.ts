import type { NetworkLayer } from "../../network";
import { defineComponentSystem } from "@latticexyz/recs";
import { entities, indexToID } from "../modules/entities";

export function createAbilityPlaySystem(network: NetworkLayer) {
  const {
    world,
    components: { AbilityPlay },
  } = network;

  defineComponentSystem(world, AbilityPlay, (update) => {
    console.log("==> AbilityPlay system: ", update);
    const abilityPlay = update.value[0]?.value;
    entities.update((value) => {
      if (!value[indexToID(update.entity)]) value[indexToID(update.entity)] = {};
      value[indexToID(update.entity)].abilityPlay = abilityPlay;
      return value;
    });
  });
}
