// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;
import "solecs/System.sol";
import { IWorld } from "solecs/interfaces/IWorld.sol";

import { LibConfig } from "../libraries/LibConfig.sol";
import { LibMap } from "../libraries/LibMap.sol";
import { LibAbility } from "../libraries/LibAbility.sol";
import { LibInventory } from "../libraries/LibInventory.sol";

import { Coord } from "../components/PositionComponent.sol";
import { GameConfig } from "../components/GameConfigComponent.sol";

import { ID as AbilityPlayComponentID } from "../components/AbilityPlayComponent.sol";
import { ID as AbilityBurnComponentID } from "../components/AbilityBurnComponent.sol";

uint256 constant ID = uint256(keccak256("system.Init"));

contract InitSystem is System {
  constructor(IWorld _world, address _components) System(_world, _components) {}

  function execute(bytes memory arguments) public returns (bytes memory) {
    require(!LibConfig.isInitialized(components), "InitSystem: already initialized");

    GameConfig memory gameConfig = GameConfig({
      worldHeight: 10,
      worldWidth: 10,
      initialEnergy: 100,
      matterPerTile: 100,
      defaultCarryingCapacity: 10,
      moveCost: 10,
      extractCost: 10,
      pickUpCost: 5,
      dropCost: 5,
      transferCost: 5,
      playCost: 50,
      burnCost: 10,
      moveCooldown: 1,
      extractCooldown: 1,
      burnTime: 10
    });
    LibConfig.setGameConfig(components, gameConfig);

    // Create initial entities
    LibMap.createUntraversable(world, components, Coord(4, 0));
    LibMap.createUntraversable(world, components, Coord(4, 2));
    LibMap.createUntraversable(world, components, Coord(4, 3));
    LibMap.createUntraversable(world, components, Coord(4, 5));
    LibMap.createUntraversable(world, components, Coord(4, 6));
    LibMap.createUntraversable(world, components, Coord(4, 9));

    uint256 burnCache1 = LibMap.createUntraversable(world, components, Coord(4, 1));
    uint256 burnCache2 = LibMap.createUntraversable(world, components, Coord(4, 8));
    uint256 playCache = LibMap.createUntraversable(world, components, Coord(4, 4));

    // Place an item allowing Play in inventory
    uint256 abilityPlayItem = world.getUniqueEntityId();
    LibAbility.giveAbility(components, abilityPlayItem, AbilityPlayComponentID);
    LibInventory.makePortable(components, abilityPlayItem);
    LibInventory.addToInventory(components, playCache, abilityPlayItem);

    // Place an item allowing Burn in inventory
    uint256 abilityBurnItem1 = world.getUniqueEntityId();
    LibAbility.giveAbility(components, abilityBurnItem1, AbilityBurnComponentID);
    LibInventory.makePortable(components, abilityBurnItem1);
    LibInventory.addToInventory(components, burnCache1, abilityBurnItem1);

    // Place an item allowing Burn in inventory
    uint256 abilityBurnItem2 = world.getUniqueEntityId();
    LibAbility.giveAbility(components, abilityBurnItem2, AbilityBurnComponentID);
    LibInventory.makePortable(components, abilityBurnItem2);
    LibInventory.addToInventory(components, burnCache2, abilityBurnItem2);
  }

  function executeTyped() public returns (bytes memory) {
    return execute(abi.encode());
  }
}
