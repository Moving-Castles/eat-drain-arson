import { defineComponentSystem } from "@latticexyz/recs";
import type { NetworkLayer } from "../../network";
import { entities, indexToID } from "../modules/entities";
import { addToLog, EventCategory } from "../modules/narrator";

export function createPlayingSystem(network: NetworkLayer) {
  const {
    world,
    components: { Playing },
  } = network;

  defineComponentSystem(world, Playing, (update) => {
    console.log("==> Playing: ", update);
    const playing = update.value[0]?.value;
    entities.update((value) => {
      if (!value[indexToID(update.entity)]) value[indexToID(update.entity)] = {};
      value[indexToID(update.entity)].playing = playing;
      return value;
    });

    addToLog(update, EventCategory.Play);
  });
}
