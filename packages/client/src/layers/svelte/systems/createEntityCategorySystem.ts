import { defineComponentSystem } from "@latticexyz/recs";
import type { NetworkLayer } from "../../network";
import { entities, indexToID, EntityCategory as E } from "../modules/entities";
import { addToLog, EventCategory } from "../modules/narrator";

export function createEntityCategorySystem(network: NetworkLayer) {
  const {
    world,
    components: { EntityCategory },
  } = network;

  defineComponentSystem(world, EntityCategory, (update) => {
    console.log("==> EntityCategory system: ", update);

    const entityCategory = update.value[0]?.value;

    entities.update((value) => {
      if (!value[indexToID(update.entity)]) value[indexToID(update.entity)] = {};
      value[indexToID(update.entity)].entityCategory = entityCategory;
      return value;
    });

    if (entityCategory == E.Player) {
      addToLog(update, EventCategory.Birth);
    }

    if (entityCategory == E.Corpse) {
      addToLog(update, EventCategory.Death);
    }
  });
}
