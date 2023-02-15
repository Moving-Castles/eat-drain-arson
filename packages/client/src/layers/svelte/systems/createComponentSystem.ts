import { defineComponentSystem } from "@latticexyz/recs";
import type { NetworkLayer } from "../../network";
import { entities, indexToID } from "../modules/entities";

const toCamelCase = (s: string) => s.charAt(0).toLowerCase() + s.slice(1);

export function createComponentSystem(network: NetworkLayer, componentKey: string) {
  const { world, components } = network;

  const component = components[componentKey];

  defineComponentSystem(world, component, (update) => {
    console.log("==>", component.id, update.entity, update.value[0]);

    // Single-value components have a "value" property, structs do not
    const newValue =
      update.value[0] && Object.prototype.hasOwnProperty.call(update.value[0], "value")
        ? update.value[0].value
        : update.value[0];

    const entityID = indexToID(update.entity);
    const propertyName = toCamelCase(component.id);

    entities.update((value) => {
      // Create an empty entity if it does not exist
      if (value[entityID] === undefined) value[entityID] = {};

      if (newValue === undefined) {
        delete value[entityID][propertyName];
      } else {
        value[entityID][propertyName] = newValue;
      }

      return value;
    });
  });
}
