import type { ComponentUpdate } from "@latticexyz/recs";
import type { EntityType } from "../modules/entities";
import type { NetworkLayer } from "../../network";
import { defineComponentSystem } from "@latticexyz/recs";
import { entities, indexToID } from "../modules/entities";

export function createReadyBlockSystem(network: NetworkLayer) {
  const {
    world,
    components: { ReadyBlock },
  } = network;

  defineComponentSystem(world, ReadyBlock, (update) => {
    console.log("==> ReadyBlock system: ", update);
    const readyBlock = update.value[0]?.value;
    entities.update((value) => {
      if (!value[indexToID(update.entity)]) value[indexToID(update.entity)] = {};
      value[indexToID(update.entity)].readyBlock = readyBlock;
      return value;
    });
  });
}
