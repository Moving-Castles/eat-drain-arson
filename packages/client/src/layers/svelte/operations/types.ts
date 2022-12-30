import { Entity } from "../stores/entities";
import { ContractTransaction } from "ethers";

interface Metadata {
  description: string;
  errorMessage: string;
  positiveMessage?: string;
  negativeMessage?: string;
  lore?: string[];
}

interface Cost {
  [key: string]: number;
}

export interface Operation {
  name: string;
  category: OperationCategory;
  metadata: Metadata;
  costs: Cost[];
  requirement: (costs: Cost[]) => boolean;
  execute: () => Promise<ContractTransaction> | false;
}

export enum OperationCategory {
  Empty,
  Move,
  Gather,
  Consume,
  Burn,
  Play,
  Gate,
  Special,
}

export const OperationCategoryString = {
  [OperationCategory.Empty]: "empty",
  [OperationCategory.Move]: "move",
  [OperationCategory.Gather]: "gather",
  [OperationCategory.Consume]: "consume",
  [OperationCategory.Burn]: "burn",
  [OperationCategory.Play]: "play",
  [OperationCategory.Special]: "special",
};

export function checkCosts(costs: Cost[], player: Entity) {
  for (const [key, value] of Object.entries(costs)) {
    if (player[key] < value) return false;
  }
  return true;
}
