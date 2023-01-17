import type { SystemTypes } from "contracts/types/SystemTypes";
import type { GameConfig } from "./config";

import { createWorld } from "@latticexyz/recs";
import { setupDevSystems } from "./setup";
import {
  createActionSystem,
  setupMUDNetwork,
  defineCoordComponent,
  defineNumberComponent,
  defineBoolComponent,
  defineStringComponent,
} from "@latticexyz/std-client";
import { createFaucetService } from "@latticexyz/network";
import { defineLoadingStateComponent, defineInventoryComponent } from "./components";
import { SystemAbis } from "contracts/types/SystemAbis.mjs";
import { getNetworkConfig } from "./config";
import { BigNumber, utils } from "ethers";

/**
 * The Network layer is the lowest layer in the client architecture.
 * Its purpose is to synchronize the client components with the contract components.
 */
export async function createNetworkLayer(config: GameConfig) {
  console.log("Network config", config);

  // --- WORLD ----------------------------------------------------------------------
  const world = createWorld();

  // --- COMPONENTS -----------------------------------------------------------------
  const components = {
    LoadingState: defineLoadingStateComponent(world),
    Position: defineCoordComponent(world, { id: "Position", metadata: { contractId: "component.Position" } }),
    Energy: defineNumberComponent(world, { id: "Energy", metadata: { contractId: "component.Energy" } }),
    Matter: defineNumberComponent(world, { id: "Matter", metadata: { contractId: "component.Matter" } }),
    Control: defineStringComponent(world, { id: "Control", metadata: { contractId: "component.Control" } }),
    CreationBlock: defineNumberComponent(world, {
      id: "CreationBlock",
      metadata: { contractId: "component.CreationBlock" },
    }),
    ExpirationBlock: defineNumberComponent(world, {
      id: "ExpirationBlock",
      metadata: { contractId: "component.ExpirationBlock" },
    }),
    ReadyBlock: defineNumberComponent(world, { id: "ReadyBlock", metadata: { contractId: "component.ReadyBlock" } }),
    Portable: defineBoolComponent(world, { id: "Portable", metadata: { contractId: "component.Portable" } }),
    Inventory: defineNumberComponent(world, { id: "Inventory", metadata: { contractId: "component.Inventory" } }),
    // Inventory: defineInventoryComponent(world),
  };

  // --- SETUP ----------------------------------------------------------------------
  const { txQueue, systems, txReduced$, network, startSync, encoders } = await setupMUDNetwork<
    typeof components,
    SystemTypes
  >(getNetworkConfig(config), world, components, SystemAbis);

  // Faucet setup
  const faucet = config.faucetServiceUrl ? createFaucetService(config.faucetServiceUrl) : undefined;
  const address = network.connectedAddress.get();
  console.log("player address:", address);

  async function requestDrip() {
    const playerIsBroke = (await network.signer.get()?.getBalance())?.lte(utils.parseEther("0.05"));
    if (playerIsBroke) {
      console.info("[Dev Faucet] Dripping funds to player");
      // Double drip
      address && (await faucet?.dripDev({ address })) && (await faucet?.dripDev({ address }));
    }
  }

  requestDrip();
  // Request a drip every 20 seconds
  setInterval(requestDrip, 20000);

  // --- ACTION SYSTEM --------------------------------------------------------------
  const actions = createActionSystem(world, txReduced$);

  // --- API ------------------------------------------------------------------------
  function spawn() {
    systems["system.Spawn"].executeTyped(BigNumber.from(network.connectedAddress.get()));
  }

  function move(energyInput: number, direction: number) {
    return false;
    // return systems["system.Move"].executeTyped(BigNumber.from(network.connectedAddress.get()), energyInput, direction);
  }

  function gather(energyInput: number) {
    return false;

    // return systems["system.Gather"].executeTyped(BigNumber.from(network.connectedAddress.get()), energyInput);
  }

  function consume(resourceInput: number) {
    return false;
    // return systems["system.Energy"].executeTyped(BigNumber.from(network.connectedAddress.get()), resourceInput);
  }

  function burn(resourceInput: number) {
    return false;
    // return systems["system.Fire"].executeTyped(BigNumber.from(network.connectedAddress.get()), resourceInput);
  }

  function play(energyInput: number) {
    return false;
    // return systems["system.Play"].executeTyped(BigNumber.from(network.connectedAddress.get()), energyInput);
  }

  // --- CONTEXT --------------------------------------------------------------------
  const context = {
    world,
    components,
    txQueue,
    systems,
    txReduced$,
    startSync,
    network,
    actions,
    api: { spawn, move, gather, consume, burn, play },
    dev: setupDevSystems(world, encoders, systems),
  };

  return context;
}
