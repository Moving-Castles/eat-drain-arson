import { get } from "svelte/store";
import { Operation, OperationCategory } from "../types";
import { network } from "../../stores/network";
import { player } from "../../stores/player";
import { Directions } from "../../utils/space";

export const giveUp: Operation = {
  name: "give up",
  category: OperationCategory.Special,
  metadata: {
    description: "What is the point to it all, anyways",
    lore: [
      "Shame to lose it all here. Cursed be the one that robs a corpse they haven’t killed themselves!",
      "Tell all the animals.",
      "“!Eternity! ٩(｡•́‿•̀｡)۶",
      "And you shall go down with me!",
    ],
    errorMessage: "You failed to give up...",
  },
  costs: [],
  requirement: () => true,
  execute: () => {
    // Spend all energy
    return get(network).api?.move(get(player).energy || 0, Directions.South);
  },
};
