import { get } from "svelte/store";
import { network } from "../../modules/network";
import { player } from "../../modules/player";
import { fires } from "../../modules/entities";
import { transformationToDirection, positionsToTransformation, directionalPathfind } from "../../utils/space";
import { Operation, OperationCategory } from "../types";
import { checkCosts } from "../utils";

export const goTowardsFire: Operation = {
  name: "go towards fire",
  category: OperationCategory.Move,
  metadata: {
    description: "Move 3 step in random direction",
    lore: [
      "I’d rather sleep in the dark, but if the maggots don’t get me, the cold will.",
      "50/50 chance this is a good idea.",
      "Here are creatures who build diligently, but no leader in sight, I might join them.",
    ],
    errorMessage: "Movement failed",
  },
  costs: [
    {
      energy: 10,
    },
  ],
  requirement: (costs) => {
    if (!checkCosts(costs, get(player))) return false;
    if (get(fires).length < 1) return false;
    return true;
  },
  execute: () => {
    const paths = [];

    for (let i = 0; i < get(fires).length; i++) {
      // Get path between player and fire
      const path = directionalPathfind(get(player).position, get(fires)[i].position);
      paths.push({ path: path, distance: path.length });
    }

    paths.sort((a, b) => a.distance - b.distance);

    // We are at fire
    if (paths[0].path.length < 1) return false;

    // Take the first step towards the closest fire
    const t = positionsToTransformation(get(player).position, paths[0].path[0]);
    return get(network).api?.move(10, transformationToDirection(t));
  },
};
