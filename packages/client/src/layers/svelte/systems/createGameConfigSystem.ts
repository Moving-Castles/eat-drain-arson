import type { ComponentUpdate } from "@latticexyz/recs";
import type { EntityType } from "../modules/entities";
import type { NetworkLayer } from "../../network";
import { defineComponentSystem } from "@latticexyz/recs";
import { entities, indexToID } from "../modules/entities";

export function createGameConfigSystem(network: NetworkLayer) {
  const {
    world,
    components: { GameConfig },
  } = network;

  defineComponentSystem(world, GameConfig, (update) => {
    console.log("==> GameConfig system: ", update);
    const gameConfig = update.value[0];
    entities.update((value) => {
      if (!value[indexToID(update.entity)]) value[indexToID(update.entity)] = {};
      value[indexToID(update.entity)].gameConfig = gameConfig;
      return value;
    });
  });
}
