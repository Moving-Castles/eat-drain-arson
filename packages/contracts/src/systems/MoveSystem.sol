// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;

import "solecs/System.sol";
import { IWorld } from "solecs/interfaces/IWorld.sol";
import { getAddressById, addressToEntity } from "solecs/utils.sol";

import { LibMove } from "../libraries/LibMove.sol";
import { LibCore } from "../libraries/LibCore.sol";
import { LibInventory } from "../libraries/LibInventory.sol";
import { LibAbility } from "../libraries/LibAbility.sol";
import { LibConfig } from "../libraries/LibConfig.sol";

import { GameConfig } from "../components/GameConfigComponent.sol";
import { ID as AbilityMoveComponentID } from "../components/AbilityMoveComponent.sol";

import { Coord } from "../components/PositionComponent.sol";

uint256 constant ID = uint256(keccak256("system.Move"));

contract MoveSystem is System {
  constructor(IWorld _world, address _components) System(_world, _components) {}

  function execute(bytes memory arguments) public returns (bytes memory) {
    Coord memory _targetPosition = abi.decode(arguments, (Coord));
    uint256 coreEntity = addressToEntity(msg.sender);

    GameConfig memory gameConfig = LibConfig.getGameConfig(components);

    require(LibCore.isSpawned(components, coreEntity), "MoveSystem: entity does not exist");
    require(LibCore.isReady(components, coreEntity), "MoveSystem: entity is in cooldown");
    require(!LibCore.isCommitted(components, coreEntity), "MoveSystem: entity is committed");
    require(LibCore.checkEnergy(components, coreEntity, gameConfig.moveCost), "MoveSystem: not enough energy");

    uint256 baseEntity = LibInventory.getCarriedBy(components, coreEntity);

    uint32 abilityCount = LibAbility.checkInventoryForAbility(components, baseEntity, AbilityMoveComponentID);
    require(abilityCount > 0, "MoveSystem: no item with AbilityMove");

    LibMove.step(components, baseEntity, _targetPosition);

    // Apply discount if entity has more than one "movement organ"
    uint32 calculatedMoveCost = gameConfig.moveCost - (2 * (abilityCount - 1));

    LibCore.decreaseEnergy(components, coreEntity, calculatedMoveCost);
    LibCore.setReadyBlock(components, coreEntity, gameConfig.moveCooldown);
  }

  function executeTyped(Coord memory _targetPosition) public returns (bytes memory) {
    return execute(abi.encode(_targetPosition));
  }
}
