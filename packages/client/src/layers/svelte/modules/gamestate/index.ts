import type { Entity, Entities } from "../entities";
import { entities as entityStore } from "../entities";
import { tweened } from "svelte/motion";
import { writable, get } from "svelte/store";

/** Map default durations for tweening */
const entityDurations = {
  creationBlock: false,
  readyBlock: false,
  matter: 1000,
  energy: 1000,
  position: 100,
  portable: false,
  carryingCapacity: false,
  core: false,
  carriedBy: false,
};

// Writable store with writable entities inside 🥴
export const addresses = writable([]);
export const entities = writable({});

/** Make all available properties on an Entity tweenable */
export const makeTweenedEntity = (address: string, entity: Entity) => {
  return writable(
    Object.fromEntries(
      Object.entries(entity).map(([k, v]) => {
        const d = entityDurations[k];

        if (d !== false && !!v) {
          return [k, tweened(v, d)];
        }

        return [k, v];
      })
    )
  );
};

/** Update all tweens on a tweened entity */
export const updateTweenedEntity = (address: string, entity: Entity) => {
  Object.entries(entity).forEach(([k, v]) => {
    const d = entityDurations[k];

    if (d !== false && !!v) {
      // console.log(typeof v);
      // console.log(v);
      // console.log(v?.subscribe);
    }
  });
};

export const getTweenedEntity = (address: string) => get(entities)[address];

/**
 * Create a tweened version of each property that's available on the entity
 * And recursively update those values if they are new
 */
entityStore.subscribe(($entities: Entities) => {
  Object.entries($entities).forEach(([address, newValue]) => {
    if (!Object.keys(entities).includes(address)) {
      addresses.set([...getaddresses, address]);
    }
  });
});
