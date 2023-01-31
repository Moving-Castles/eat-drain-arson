import type { NetworkLayer } from "../../network";
import { defineComponentSystem } from "@latticexyz/recs";
import { entities, indexToID } from "../modules/entities";

export function createAbilityMoveSystem(network: NetworkLayer) {
  const {
    world,
    components: { AbilityMove },
  } = network;

  defineComponentSystem(world, AbilityMove, (update) => {
    console.log("==> AbilityMove system: ", update);
    const abilityMove = update.value[0]?.value;
    entities.update((value) => {
      if (!value[indexToID(update.entity)]) value[indexToID(update.entity)] = {};
      value[indexToID(update.entity)].abilityMove = abilityMove;
      return value;
    });
  });
}
