import { defineComponentSystem } from "@latticexyz/recs";
import type { NetworkLayer } from "../../network";
import { entities, indexToID } from "../modules/entities";
import { addToLog, EventCategory } from "../modules/narrator";

export function createMatterSystem(network: NetworkLayer) {
  const {
    world,
    components: { Matter },
  } = network;

  defineComponentSystem(world, Matter, (update) => {
    console.log("==> Matter system: ", update);
    const oldMatter = update.value[1]?.value || 0;
    const matter = update.value[0]?.value || 0;
    entities.update((value) => {
      if (!value[indexToID(update.entity)]) value[indexToID(update.entity)] = {};
      value[indexToID(update.entity)].matter = matter;
      return value;
    });

    // if (matter > oldMatter) {
    //   addToLog(update, EventCategory.Gather);
    // }
  });
}
