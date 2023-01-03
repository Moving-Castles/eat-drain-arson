import { ContractTransaction } from "ethers";

type Metadata = {
  description: string;
  errorMessage: string;
  positiveMessage?: string;
  negativeMessage?: string;
  lore?: string[];
};

export type Cost = {
  [key: string]: number;
};

export type Operation = {
  name: string;
  category: OperationCategory;
  metadata: Metadata;
  costs: Cost[];
  requirement: (costs: Cost[]) => boolean;
  execute: () => Promise<ContractTransaction> | false;
};

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
