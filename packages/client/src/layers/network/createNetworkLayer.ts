import type { SystemTypes } from "contracts/types/SystemTypes";
import type { GameConfig } from "./config";
import { createWorld } from "@latticexyz/recs";
import { setupDevSystems } from "./setup";
import { createActionSystem, setupMUDNetwork } from "@latticexyz/std-client";
import { createFaucetService } from "@latticexyz/network";
import {
  defineLoadingStateComponent,
  defineGameConfigComponent,
  defineCreationBlockComponent,
  defineEnergyComponent,
  defineMatterComponent,
  definePortableComponent,
  definePositionComponent,
  defineReadyBlockComponent,
  defineCarryingCapacityComponent,
  defineCarriedByComponent,
  defineCoreComponent,
  defineAbilityMoveComponent,
  defineAbilityConsumeComponent,
  defineAbilityExtractComponent,
  defineAbilityPlayComponent,
  defineAbilityBurnComponent,
  defineUntraversableComponent,
  defineCommitComponent,
  defineBurnBlockComponent,
} from "./components";
import { SystemAbis } from "contracts/types/SystemAbis.mjs";
import { getNetworkConfig } from "./config";
import { utils } from "ethers";

/**
 * The Network layer is the lowest layer in the client architecture.
 * Its purpose is to synchronize the client components with the contract components.
 */
export async function createNetworkLayer(config: GameConfig) {
  // --- WORLD ----------------------------------------------------------------------
  const world = createWorld();

  // --- COMPONENTS -----------------------------------------------------------------
  const components = {
    LoadingState: defineLoadingStateComponent(world),
    GameConfig: defineGameConfigComponent(world),
    Position: definePositionComponent(world),
    Energy: defineEnergyComponent(world),
    Matter: defineMatterComponent(world),
    CreationBlock: defineCreationBlockComponent(world),
    ReadyBlock: defineReadyBlockComponent(world),
    BurnBlock: defineBurnBlockComponent(world),
    Portable: definePortableComponent(world),
    CarryingCapacity: defineCarryingCapacityComponent(world),
    CarriedBy: defineCarriedByComponent(world),
    Core: defineCoreComponent(world),
    AbilityMove: defineAbilityMoveComponent(world),
    AbilityConsume: defineAbilityConsumeComponent(world),
    AbilityExtract: defineAbilityExtractComponent(world),
    AbilityPlay: defineAbilityPlayComponent(world),
    AbilityBurn: defineAbilityBurnComponent(world),
    Untraversable: defineUntraversableComponent(world),
    Commit: defineCommitComponent(world),
  };

  // --- SETUP ----------------------------------------------------------------------
  const { txQueue, systems, txReduced$, network, startSync, encoders, systemCallStreams } = await setupMUDNetwork<
    typeof components,
    SystemTypes
  >(getNetworkConfig(config), world, components, SystemAbis, { fetchSystemCalls: true });

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
    try {
      systems["system.Spawn"].executeTyped();
    } catch (e) {
      window.alert(e);
    }
  }

  // async function addToTxLog(tx: ContractTransaction, description: string) {
  //   transactions.update((value) => [...value, { hash: tx.hash, description: description }]);
  //   const receipt: ContractReceipt = await tx.wait();
  //   receipts.update((value) => [...value, receipt]);
  // }

  // async function move(targetPosition: Coord) {
  //   try {
  //     addToTxLog(await systems["system.Move"].executeTyped(targetPosition), "move");
  //   } catch (e) {
  //     window.alert(e);
  //   }
  // }

  // async function extract(extractionCoordinates: Coord) {
  //   try {
  //     addToTxLog(await systems["system.Extract"].executeTyped(extractionCoordinates), "extract");
  //   } catch (e) {
  //     window.alert(e);
  //   }
  // }

  // async function pickUp(portableEntity: string) {
  //   try {
  //     addToTxLog(await systems["system.PickUp"].executeTyped(portableEntity), "pickUp");
  //   } catch (e) {
  //     window.alert(e);
  //   }
  // }

  // async function drop(portableEntity: string) {
  //   try {
  //     addToTxLog(await systems["system.Drop"].executeTyped(portableEntity), "drop");
  //   } catch (e) {
  //     window.alert(e);
  //   }
  // }

  // async function transfer(portableEntity: string, targetBaseEntity: string) {
  //   try {
  //     addToTxLog(await systems["system.Transfer"].executeTyped(portableEntity, targetBaseEntity), "transfer");
  //   } catch (e) {
  //     window.alert(e);
  //   }
  // }

  // async function consume(substanceBlockEntity: string) {
  //   try {
  //     addToTxLog(await systems["system.Consume"].executeTyped(substanceBlockEntity), "consume");
  //   } catch (e) {
  //     window.alert(e);
  //   }
  // }

  // async function play() {
  //   try {
  //     addToTxLog(await systems["system.Play"].executeTyped(), "play");
  //   } catch (e) {
  //     window.alert(e);
  //   }
  // }

  // async function burn(substanceBlockEntity: string) {
  //   try {
  //     addToTxLog(await systems["system.Burn"].executeTyped(substanceBlockEntity), "burn");
  //   } catch (e) {
  //     window.alert(e);
  //   }
  // }

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
    systemCallStreams,
    api: { spawn },
    dev: setupDevSystems(world, encoders, systems),
  };

  return context;
}
