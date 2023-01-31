// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;

import "solecs/System.sol";
import { IWorld } from "solecs/interfaces/IWorld.sol";
import { getAddressById, addressToEntity } from "solecs/utils.sol";

import { Direction } from "../utils/constants.sol";

import { LibMove } from "../libraries/LibMove.sol";
import { LibCore } from "../libraries/LibCore.sol";
import { LibCooldown } from "../libraries/LibCooldown.sol";
import { LibInventory } from "../libraries/LibInventory.sol";
import { LibAbility } from "../libraries/LibAbility.sol";
import { LibConfig } from "../libraries/LibConfig.sol";

import { GameConfig } from "../components/GameConfigComponent.sol";
import { ID as AbilityMoveComponentID } from "../components/AbilityMoveComponent.sol";

uint256 constant ID = uint256(keccak256("system.Move"));

contract MoveSystem is System {
  constructor(IWorld _world, address _components) System(_world, _components) {}

  function execute(bytes memory arguments) public returns (bytes memory) {
    uint32 _direction = abi.decode(arguments, (uint32));
    uint256 coreEntity = addressToEntity(msg.sender);

    GameConfig memory gameConfig = LibConfig.getGameConfig(components);

    require(LibCore.isSpawned(components, coreEntity), "MoveSystem: entity does not exist");
    require(LibCooldown.isReady(components, coreEntity), "MoveSystem: entity is in cooldown");
    require(LibCore.checkEnergy(components, coreEntity, gameConfig.moveCost), "MoveSystem: not enough energy");

    uint256 baseEntity = LibInventory.getCarriedBy(components, coreEntity);

    require(
      LibAbility.checkInventoryForAbility(components, baseEntity, AbilityMoveComponentID),
      "MoveSystem: no item with AbilityMove"
    );

    LibMove.step(components, baseEntity, Direction(_direction));

    LibCore.decreaseEnergy(components, coreEntity, gameConfig.moveCost);
    LibCooldown.setReadyBlock(components, coreEntity, gameConfig.moveCost);
  }

  function executeTyped(uint32 _direction) public returns (bytes memory) {
    return execute(abi.encode(_direction));
  }
}
