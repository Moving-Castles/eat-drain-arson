// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;
import "solecs/System.sol";
import { IWorld } from "solecs/interfaces/IWorld.sol";
import { getAddressById, addressToEntity } from "solecs/utils.sol";

import { LibInventory } from "../libraries/LibInventory.sol";
import { LibCore } from "../libraries/LibCore.sol";
import { LibMove } from "../libraries/LibMove.sol";

uint256 constant ID = uint256(keccak256("system.Spawn"));

contract SpawnSystem is System {
  constructor(IWorld _world, address _components) System(_world, _components) {}

  function execute(bytes memory arguments) public returns (bytes memory) {
    uint256 coreEntity = addressToEntity(msg.sender);
    require(!LibCore.isSpawned(components, coreEntity), "SpawnSystem: entity with this ID already exists");

    uint256 baseEntity = world.getUniqueEntityId();
    LibCore.spawn(components, coreEntity);
    LibCore.setControlledEntity(components, coreEntity, baseEntity);
    LibInventory.addToInventory(components, baseEntity, coreEntity);
    LibMove.setRandomPosition(components, baseEntity);
  }

  function executeTyped() public returns (bytes memory) {
    return execute(abi.encode());
  }
}
