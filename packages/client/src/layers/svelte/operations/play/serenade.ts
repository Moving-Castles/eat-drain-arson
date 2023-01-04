import { get } from "svelte/store";
import type { Operation } from "../types";
import { OperationCategory } from "../types";
import { checkCosts } from "../utils";
import { network } from "../../modules/network";
import { player } from "../../modules/player";

export const serenade: Operation = {
  name: "serenade",
  category: OperationCategory.Play,
  metadata: {
    description: "(╥﹏╥)",
    lore: [
      "I shall play, till they long for a place far away,- longing will make them soft, and soft pockets are easier to pierce.",
      "This song is for all the owls <3",
      "This song goes out to all of you, and to you big daddy-energy hill of paratrash!",
      "Tonight, it is I who shall play for you, this one is a song from the depths of my fifth chakra, listen to it ring!",
    ],
    errorMessage: "Serenade failed: not enough energy",
  },
  costs: [
    {
      energy: 100,
    },
  ],
  requirement: (costs) => {
    if (!checkCosts(costs, get(player))) return false;
    return true;
  },
  execute: () => {
    return get(network).api?.play(100);
  },
};
