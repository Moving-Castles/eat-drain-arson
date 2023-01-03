import { writable, derived } from "svelte/store";
import { NetworkLayer } from "../../../network";
import type { ContractReceipt } from "ethers";

// --- STORES -----------------------------------------------------------------

export const network = writable({} as NetworkLayer);
export const blockNumber = writable(0);
export const ready = writable(false);
export const loadingMessage = writable("Loading");
export const startBlock = writable(0);
export const transactions = writable([] as string[]);
export const receipts = writable([] as ContractReceipt[]);
// Get transaction that do not have a matching receipt
export const activeTransactions = derived([transactions, receipts], ([$transactions, $receipts]) =>
  $transactions.filter((t) => !$receipts.find((r) => r.transactionHash === t))
);
