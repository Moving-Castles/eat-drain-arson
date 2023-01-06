import { get } from "svelte/store";
import type { Operation } from "../types";
import { OperationType } from "../types";
import { checkCosts } from "../utils";
import { network } from "../../modules/network";
import { player } from "../../modules/player";

export const fire: Operation = {
  name: "fire",
  category: OperationType.Burn,
  metadata: {
    description: "This will keep me warm me at night",
    lore: [
      "Let’s hope that tonight’s light attracts the fat moths, not the hungry ones.",
      "There's no smoke without fire, and smoke is just what this flea leather needs. Isn’t that right, Lewis?",
      "From the debris to the stars.",
      "Fire fire, burning bright throughout the night, bless me, bless me for I am your strongest warrior.",
    ],
    errorMessage: "Can't make fire",
  },
  costs: [
    {
      energy: 50,
      resource: 500,
    },
  ],
  requirement: (costs) => {
    if (!checkCosts(costs, get(player))) return false;
    return true;
  },
  execute: () => {
    return get(network).api?.burn(500);
  },
};
