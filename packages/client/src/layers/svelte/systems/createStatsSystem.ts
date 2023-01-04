import { defineComponentSystem } from "@latticexyz/recs";
import type { NetworkLayer } from "../../network";
import type { StatsType } from "../modules/entities";
import { entities, indexToID } from "../modules/entities";
import { addToLog, EventCategory } from "../modules/narrator";

export function createStatsSystem(network: NetworkLayer) {
  const {
    world,
    components: { Stats },
  } = network;

  defineComponentSystem(world, Stats, (update) => {
    console.log("==> Stats system: ", update);
    const stats: StatsType = update.value[0];
    entities.update((value) => {
      if (!value[indexToID(update.entity)]) value[indexToID(update.entity)] = {};
      value[indexToID(update.entity)].stats = stats;
      return value;
    });
  });
}
