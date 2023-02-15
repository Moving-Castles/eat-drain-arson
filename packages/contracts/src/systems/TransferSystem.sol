// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;
import "solecs/System.sol";
import { IWorld } from "solecs/interfaces/IWorld.sol";
import { getAddressById, addressToEntity } from "solecs/utils.sol";

import { LibMove } from "../libraries/LibMove.sol";
import { LibCore } from "../libraries/LibCore.sol";
import { LibMap } from "../libraries/LibMap.sol";
import { LibInventory } from "../libraries/LibInventory.sol";
import { LibConfig } from "../libraries/LibConfig.sol";

import { GameConfig } from "../components/GameConfigComponent.sol";
import { Coord } from "../components/PositionComponent.sol";

uint256 constant ID = uint256(keccak256("system.Transfer"));

contract TransferSystem is System {
  constructor(IWorld _world, address _components) System(_world, _components) {}

  function execute(bytes memory arguments) public returns (bytes memory) {
    (uint256 _portableEntity, uint256 _targetBaseEntity) = abi.decode(arguments, (uint256, uint256));
    uint256 coreEntity = addressToEntity(msg.sender);

    GameConfig memory gameConfig = LibConfig.getGameConfig(components);

    require(LibCore.isSpawned(components, coreEntity), "TransferSystem: entity does not exist");
    require(LibCore.isReady(components, coreEntity), "TransferSystem: entity is in cooldown");
    require(!LibCore.isCommitted(components, coreEntity), "TransferSystem: entity is committed");
    require(LibCore.checkEnergy(components, coreEntity, gameConfig.transferCost), "TransferSystem: not enough energy");

    uint256 baseEntity = LibInventory.getCarriedBy(components, coreEntity);
    require(LibInventory.isCarriedBy(components, _portableEntity, baseEntity), "TransferSystem: not carried by caller");

    Coord memory baseEntityPosition = LibMove.getPosition(components, baseEntity);
    Coord memory targetBaseEntityPosition = LibMove.getPosition(components, _targetBaseEntity);
    require(LibMap.isAdjacent(baseEntityPosition, targetBaseEntityPosition), "TransferSystem: not adjacent");

    LibInventory.addToInventory(components, _targetBaseEntity, _portableEntity);

    LibCore.decreaseEnergy(components, coreEntity, gameConfig.transferCost);

    // If the inventory is empty, remove the baseEntity
    if (LibInventory.getInventorySize(components, baseEntity) == 0) {
      LibMove.removePosition(components, baseEntity);
      LibInventory.removeCarryingCapacity(components, baseEntity);
    }
  }

  function executeTyped(uint256 _portableEntity, uint256 _targetBaseEntity) public returns (bytes memory) {
    return execute(abi.encode(_portableEntity, _targetBaseEntity));
  }
}
