import { createNetworkLayer } from "../network";
import { Layers } from "../../types";
import { Wallet } from "ethers";

export async function bootGame() {
  const layers: Partial<Layers> = {};

  const params = new URLSearchParams(window.location.search);
  const worldAddress = params.get("worldAddress");
  let privateKey = params.get("burnerWalletPrivateKey");
  const chainId = Number(params.get("chainId")) || 31337;
  const jsonRpc = params.get("rpc") ?? "http://localhost:8545";
  const wsRpc = params.get("wsRpc") ?? "ws://localhost:8545";
  const snapshotServiceUrl = params.get("snapshot") || undefined;
  const faucetServiceUrl = params.get("faucet") || undefined;
  const devMode = params.get("dev") === "true";
  const initialBlockNumber = Number(params.get("initialBlockNumber")) || 0;

  if (!privateKey) {
    privateKey = localStorage.getItem("burnerWallet") || Wallet.createRandom().privateKey;
    localStorage.setItem("burnerWallet", privateKey);
  }

  let networkLayerConfig;
  if (worldAddress && privateKey && chainId && jsonRpc) {
    networkLayerConfig = {
      worldAddress,
      privateKey,
      chainId,
      jsonRpc,
      wsRpc,
      snapshotServiceUrl,
      faucetServiceUrl,
      devMode,
      initialBlockNumber,
    };
  }

  if (!networkLayerConfig) throw new Error("Invalid config");

  layers.network = await createNetworkLayer(networkLayerConfig);
  layers.network.startSync();

  return layers as Layers;
}
