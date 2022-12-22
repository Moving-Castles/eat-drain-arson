// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.0;

import { DSTest } from "ds-test/test.sol";
import { World } from "solecs/World.sol";
import { IUint256Component } from "solecs/interfaces/IUint256Component.sol";
import { Cheats } from "./utils/Cheats.sol";
import { Utilities } from "./utils/Utilities.sol";
import { Deploy } from "./utils/Deploy.sol";
import { componentsComponentId, systemsComponentId } from "solecs/constants.sol";
import { getAddressById } from "solecs/utils.sol";
import { console } from "forge-std/console.sol";

import { PositionComponent, ID as PositionComponentID } from "../components/PositionComponent.sol";
import { EnergyComponent, ID as EnergyComponentID } from "../components/EnergyComponent.sol";
import { ResourceComponent, ID as ResourceComponentID } from "../components/ResourceComponent.sol";
import { EntityTypeComponent, ID as EntityTypeComponentID } from "../components/EntityTypeComponent.sol";
import { SeedComponent, ID as SeedComponentID } from "../components/SeedComponent.sol";
import { CoolDownComponent, ID as CoolDownComponentID } from "../components/CoolDownComponent.sol";
import { CreatorComponent, ID as CreatorComponentID } from "../components/CreatorComponent.sol";
import { StatsComponent, ID as StatsComponentID } from "../components/StatsComponent.sol";
import { BirthComponent, ID as BirthComponentID } from "../components/BirthComponent.sol";
import { CannibalComponent, ID as CannibalComponentID } from "../components/CannibalComponent.sol";
import { PlayingComponent, ID as PlayingComponentID } from "../components/PlayingComponent.sol";
import { DeathComponent, ID as DeathComponentID } from "../components/DeathComponent.sol";

contract MudTest is DSTest {
  Cheats internal immutable vm = Cheats(HEVM_ADDRESS);
  Utilities internal immutable utils = new Utilities();

  address payable internal alice;
  address payable internal bob;
  address payable internal eve;
  address internal deployer;

  World internal world;
  IUint256Component components;
  IUint256Component systems;
  Deploy internal deploy = new Deploy();

  PositionComponent positionComponent;
  EnergyComponent energyComponent;
  ResourceComponent resourceComponent;
  EntityTypeComponent entityTypeComponent;
  SeedComponent seedComponent;
  CoolDownComponent coolDownComponent;
  CreatorComponent creatorComponent;
  StatsComponent statsComponent;
  BirthComponent birthComponent;
  CannibalComponent cannibalComponent;
  PlayingComponent playingComponent;
  DeathComponent deathComponent;

  function component(uint256 id) public view returns (address) {
    return getAddressById(components, id);
  }

  function system(uint256 id) public view returns (address) {
    return getAddressById(systems, id);
  }

  function setUp() public {
    world = deploy.deploy(address(0), address(0), false);
    components = world.components();
    systems = world.systems();
    deployer = deploy.deployer();
    alice = utils.getNextUserAddress();
    bob = utils.getNextUserAddress();
    eve = utils.getNextUserAddress();

    // Initialize components
    positionComponent = PositionComponent(component(PositionComponentID));
    energyComponent = EnergyComponent(component(EnergyComponentID));
    resourceComponent = ResourceComponent(component(ResourceComponentID));
    entityTypeComponent = EntityTypeComponent(component(EntityTypeComponentID));
    seedComponent = SeedComponent(component(SeedComponentID));
    creatorComponent = CreatorComponent(component(CreatorComponentID));
    coolDownComponent = CoolDownComponent(component(CoolDownComponentID));
    statsComponent = StatsComponent(component(StatsComponentID));
    birthComponent = BirthComponent(component(BirthComponentID));
    cannibalComponent = CannibalComponent(component(CannibalComponentID));
    playingComponent = PlayingComponent(component(PlayingComponentID));
    deathComponent = DeathComponent(component(DeathComponentID));
  }
}
