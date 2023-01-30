import type { NetworkLayer } from "../../network";
import { defineComponentSystem } from "@latticexyz/recs";
import { entities, indexToID } from "../modules/entities";

export function createAbilityExtractSystem(network: NetworkLayer) {
  const {
    world,
    components: { AbilityExtract },
  } = network;

  defineComponentSystem(world, AbilityExtract, (update) => {
    console.log("==> AbilityExtract system: ", update);
    const abilityExtract = update.value[0]?.value;
    entities.update((value) => {
      if (!value[indexToID(update.entity)]) value[indexToID(update.entity)] = {};
      value[indexToID(update.entity)].abilityExtract = abilityExtract;
      return value;
    });
  });
}
