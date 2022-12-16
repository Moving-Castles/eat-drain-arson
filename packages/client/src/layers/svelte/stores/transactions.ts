import { writable, derived } from "svelte/store";
import type { ContractReceipt } from "ethers";

export const transactions = writable([] as string[]);
export const receipts = writable([] as ContractReceipt[]);
export const activeTransactions = derived([transactions, receipts], ([$transactions, $receipts]) => {
  return $transactions.filter((t) => !$receipts.find((r) => r.transactionHash === t));
});
