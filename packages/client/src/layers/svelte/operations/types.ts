import type { ContractTransaction } from "ethers";

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
  category: OperationType;
  metadata: Metadata;
  costs: Cost[];
  requirement: (costs: Cost[]) => boolean;
  execute: () => Promise<ContractTransaction> | false;
};

export enum OperationType {
  Empty,
  Move,
  Gather,
  Consume,
  Burn,
  Play,
  Gate,
  Special,
}

export const OperationTypeString = {
  [OperationType.Empty]: "empty",
  [OperationType.Move]: "move",
  [OperationType.Gather]: "gather",
  [OperationType.Consume]: "consume",
  [OperationType.Burn]: "burn",
  [OperationType.Play]: "play",
  [OperationType.Special]: "special",
};
