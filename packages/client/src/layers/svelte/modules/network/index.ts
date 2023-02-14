import { writable, derived } from "svelte/store";
import type { NetworkLayer } from "../../../network";
import type { ContractReceipt } from "ethers";

// --- STORES -----------------------------------------------------------------

export type tx = {
  hash: string;
  description: string;
};

export const network = writable({} as NetworkLayer);
export const blockNumber = writable(0);
export const ready = writable(false);
export const loadingMessage = writable("Loading");
export const transactions = writable([] as tx[]);
export const receipts = writable([] as ContractReceipt[]);
// Get transaction that do not have a matching receipt
export const activeTransactions = derived([transactions, receipts], ([$transactions, $receipts]) =>
  $transactions.filter((t) => !$receipts.find((r) => r.transactionHash === t.hash))
);
