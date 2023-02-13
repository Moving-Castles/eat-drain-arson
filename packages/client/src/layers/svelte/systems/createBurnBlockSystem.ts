import type { ComponentUpdate } from "@latticexyz/recs";
import type { EntityType } from "../modules/entities";
import type { NetworkLayer } from "../../network";
import { defineComponentSystem } from "@latticexyz/recs";
import { entities, indexToID } from "../modules/entities";

export function createBurnBlockSystem(network: NetworkLayer) {
  const {
    world,
    components: { BurnBlock },
  } = network;

  defineComponentSystem(world, BurnBlock, (update) => {
    console.log("==> BurnBlock system: ", update);
    const burnBlock = update.value[0]?.value;
    entities.update((value) => {
      if (!value[indexToID(update.entity)]) value[indexToID(update.entity)] = {};
      value[indexToID(update.entity)].burnBlock = burnBlock;
      return value;
    });
  });
}
