import type { ComponentUpdate } from "@latticexyz/recs";
import type { EntityType } from "../modules/entities";
import type { NetworkLayer } from "../../network";
import { defineComponentSystem } from "@latticexyz/recs";
import { entities, indexToID } from "../modules/entities";

export function createCreationBlockSystem(network: NetworkLayer) {
  const {
    world,
    components: { CreationBlock },
  } = network;

  defineComponentSystem(world, CreationBlock, (update) => {
    console.log("==> CreationBlock system: ", update);
    const creationBlock = update.value[0]?.value;
    entities.update((value) => {
      if (!value[indexToID(update.entity)]) value[indexToID(update.entity)] = {};
      value[indexToID(update.entity)].creationBlock = creationBlock;
      return value;
    });
  });
}
