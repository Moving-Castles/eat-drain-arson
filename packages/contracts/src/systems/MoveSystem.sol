// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;
import "solecs/System.sol";
import { IWorld } from "solecs/interfaces/IWorld.sol";
import { getAddressById, addressToEntity } from "solecs/utils.sol";

import { Direction } from "../utils/types.sol";
import { STEP_COST } from "../utils/config.sol";

import { LibMove } from "../libraries/LibMove.sol";
import { LibCore } from "../libraries/LibCore.sol";
import { LibCooldown } from "../libraries/LibCooldown.sol";

uint256 constant ID = uint256(keccak256("system.Move"));

contract MoveSystem is System {
  constructor(IWorld _world, address _components) System(_world, _components) {}

  function execute(bytes memory arguments) public returns (bytes memory) {
    uint32 _direction = abi.decode(arguments, (uint32));
    uint256 coreEntity = addressToEntity(msg.sender);

    require(LibCore.isSpawned(components, coreEntity), "MoveSystem: entity does not exist");
    require(LibCooldown.isReady(components, coreEntity), "MoveSystem: entity is in cooldown");
    require(LibCore.checkEnergy(components, coreEntity, STEP_COST), "MoveSystem: not enough energy");

    uint256 baseEntity = LibCore.getControlledEntity(components, coreEntity);
    LibMove.step(components, baseEntity, Direction(_direction));

    LibCore.decreaseEnergy(components, coreEntity, STEP_COST);
    LibCooldown.setReadyBlock(components, coreEntity, STEP_COST);
  }

  function executeTyped(uint32 _direction) public returns (bytes memory) {
    return execute(abi.encode(_direction));
  }
}
