import type { SystemTypes } from "contracts/types/SystemTypes";
import type { GameConfig } from "./config";
import { createWorld } from "@latticexyz/recs";
import { setupDevSystems } from "./setup";
import { createActionSystem, setupMUDNetwork } from "@latticexyz/std-client";
import { createFaucetService } from "@latticexyz/network";
import {
  defineLoadingStateComponent,
  defineCreationBlockComponent,
  defineEnergyComponent,
  defineExpirationBlockComponent,
  defineMatterComponent,
  definePortableComponent,
  definePositionComponent,
  defineReadyBlockComponent,
  defineCarryingCapacityComponent,
  defineCarriedByComponent,
  defineCoreComponent,
} from "./components";
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
    Position: definePositionComponent(world),
    Energy: defineEnergyComponent(world),
    Matter: defineMatterComponent(world),
    CreationBlock: defineCreationBlockComponent(world),
    ExpirationBlock: defineExpirationBlockComponent(world),
    ReadyBlock: defineReadyBlockComponent(world),
    Portable: definePortableComponent(world),
    CarryingCapacity: defineCarryingCapacityComponent(world),
    CarriedBy: defineCarriedByComponent(world),
    Core: defineCoreComponent(world),
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
    systems["system.Spawn"].executeTyped();
  }

  function move(direction: number) {
    return systems["system.Move"].executeTyped(direction);
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
