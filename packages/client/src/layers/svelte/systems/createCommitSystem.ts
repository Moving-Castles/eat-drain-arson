import { defineComponentSystem } from "@latticexyz/recs";
import type { NetworkLayer } from "../../network";
import { entities, indexToID } from "../modules/entities";

export function createCommitSystem(network: NetworkLayer) {
  const {
    world,
    components: { Commit },
  } = network;

  defineComponentSystem(world, Commit, (update) => {
    console.log("==> Commit system: ", update);
    const commit = update.value[0]?.value;
    entities.update((value) => {
      if (!value[indexToID(update.entity)]) value[indexToID(update.entity)] = {};
      value[indexToID(update.entity)].commit = commit;
      return value;
    });
  });
}
