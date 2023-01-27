// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;
import "solecs/System.sol";
import { IWorld } from "solecs/interfaces/IWorld.sol";
import { getAddressById, addressToEntity } from "solecs/utils.sol";

import { ID as AbilityMoveComponentID } from "../components/AbilityMoveComponent.sol";
import { ID as AbilityConsumeComponentID } from "../components/AbilityConsumeComponent.sol";
import { ID as AbilityExtractComponentID } from "../components/AbilityExtractComponent.sol";

import { LibInventory } from "../libraries/LibInventory.sol";
import { LibCore } from "../libraries/LibCore.sol";
import { LibMove } from "../libraries/LibMove.sol";
import { LibAbility } from "../libraries/LibAbility.sol";

import { DEFAULT_CARRYING_CAPACITY } from "../utils/config.sol";

uint256 constant ID = uint256(keccak256("system.Spawn"));

contract SpawnSystem is System {
  constructor(IWorld _world, address _components) System(_world, _components) {}

  function execute(bytes memory arguments) public returns (bytes memory) {
    uint256 coreEntity = addressToEntity(msg.sender);

    require(!LibCore.isSpawned(components, coreEntity), "SpawnSystem: ID already exists");

    LibCore.spawn(components, coreEntity);

    // Place the core in the inventory of a new base entity
    uint256 baseEntity = world.getUniqueEntityId();
    LibInventory.setCarryingCapacity(components, baseEntity, DEFAULT_CARRYING_CAPACITY);
    LibInventory.addToInventory(components, baseEntity, coreEntity);
    LibMove.setRandomPosition(components, baseEntity);

    // Place an item allowing Move in inventory
    uint256 AbilityMoveItem = world.getUniqueEntityId();
    LibAbility.giveAbility(components, AbilityMoveItem, AbilityMoveComponentID);
    LibInventory.makePortable(components, AbilityMoveItem);
    LibInventory.addToInventory(components, baseEntity, AbilityMoveItem);

    // Place an item allowing Consume in inventory
    uint256 AbilityConsumeItem = world.getUniqueEntityId();
    LibAbility.giveAbility(components, AbilityConsumeItem, AbilityConsumeComponentID);
    LibInventory.makePortable(components, AbilityConsumeItem);
    LibInventory.addToInventory(components, baseEntity, AbilityConsumeItem);

    // Place an item allowing Extract in inventory
    uint256 AbilityExtractItem = world.getUniqueEntityId();
    LibAbility.giveAbility(components, AbilityExtractItem, AbilityExtractComponentID);
    LibInventory.makePortable(components, AbilityExtractItem);
    LibInventory.addToInventory(components, baseEntity, AbilityExtractItem);
  }

  function executeTyped() public returns (bytes memory) {
    return execute(abi.encode());
  }
}
