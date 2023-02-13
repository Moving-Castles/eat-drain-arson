import type { NetworkLayer } from "../../network";
import { defineComponentSystem } from "@latticexyz/recs";
import { entities, indexToID } from "../modules/entities";

export function createAbilityBurnSystem(network: NetworkLayer) {
  const {
    world,
    components: { AbilityBurn },
  } = network;

  defineComponentSystem(world, AbilityBurn, (update) => {
    console.log("==> AbilityBurn system:", update);
    const abilityBurn = update.value[0]?.value;
    entities.update((value) => {
      if (!value[indexToID(update.entity)]) value[indexToID(update.entity)] = {};
      value[indexToID(update.entity)].abilityBurn = abilityBurn;
      return value;
    });
  });
}
