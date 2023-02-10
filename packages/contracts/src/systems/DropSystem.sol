// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;
import "solecs/System.sol";
import { IWorld } from "solecs/interfaces/IWorld.sol";
import { getAddressById, addressToEntity } from "solecs/utils.sol";

import { LibMove } from "../libraries/LibMove.sol";
import { LibCore } from "../libraries/LibCore.sol";
import { LibCooldown } from "../libraries/LibCooldown.sol";
import { LibMap } from "../libraries/LibMap.sol";
import { LibInventory } from "../libraries/LibInventory.sol";
import { LibConfig } from "../libraries/LibConfig.sol";

import { GameConfig } from "../components/GameConfigComponent.sol";
import { Coord } from "../components/PositionComponent.sol";

uint256 constant ID = uint256(keccak256("system.Drop"));

contract DropSystem is System {
  constructor(IWorld _world, address _components) System(_world, _components) {}

  function execute(bytes memory arguments) public returns (bytes memory) {
    uint256 _portableEntity = abi.decode(arguments, (uint256));
    uint256 coreEntity = addressToEntity(msg.sender);

    GameConfig memory gameConfig = LibConfig.getGameConfig(components);

    require(LibCore.isSpawned(components, coreEntity), "DropSystem: entity does not exist");
    require(LibCooldown.isReady(components, coreEntity), "DropSystem: entity is in cooldown");
    require(!LibCore.isCommitted(components, coreEntity), "DropSystem: entity is committed");
    require(LibCore.checkEnergy(components, coreEntity, gameConfig.dropCost), "DropSystem: not enough energy");

    uint256 baseEntity = LibInventory.getCarriedBy(components, coreEntity);
    require(LibInventory.isCarriedBy(components, _portableEntity, baseEntity), "DropSystem: not carried by caller");

    Coord memory baseEntityPosition = LibMove.getPosition(components, baseEntity);

    LibInventory.removeFromInventory(components, _portableEntity);

    // Dropping a core ejects it into the void...
    if (_portableEntity == coreEntity) {
      LibMove.removePosition(components, _portableEntity);
    } else {
      LibMove.setPosition(components, _portableEntity, baseEntityPosition);
    }

    LibCore.decreaseEnergy(components, coreEntity, gameConfig.dropCost);

    // If the inventory is empty, remove the baseEntity
    if (LibInventory.getInventorySize(components, baseEntity) == 0) {
      LibMove.removePosition(components, baseEntity);
      LibInventory.removeCarryingCapacity(components, baseEntity);
    }
  }

  function executeTyped(uint256 _portableEntity) public returns (bytes memory) {
    return execute(abi.encode(_portableEntity));
  }
}
