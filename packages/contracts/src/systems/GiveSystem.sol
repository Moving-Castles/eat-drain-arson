// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;
import "solecs/System.sol";
import { IWorld } from "solecs/interfaces/IWorld.sol";
import { getAddressById, addressToEntity } from "solecs/utils.sol";

import { TRANSFER_COST } from "../utils/config.sol";

import { LibMove } from "../libraries/LibMove.sol";
import { LibCore } from "../libraries/LibCore.sol";
import { LibCooldown } from "../libraries/LibCooldown.sol";
import { LibMap } from "../libraries/LibMap.sol";
import { LibInventory } from "../libraries/LibInventory.sol";

import { Coord } from "../components/PositionComponent.sol";

uint256 constant ID = uint256(keccak256("system.Give"));

contract GiveSystem is System {
  constructor(IWorld _world, address _components) System(_world, _components) {}

  function execute(bytes memory arguments) public returns (bytes memory) {
    (uint256 _portableEntity, uint256 _targetBaseEntity) = abi.decode(arguments, (uint256, uint256));
    uint256 coreEntity = addressToEntity(msg.sender);

    require(LibCore.isSpawned(components, coreEntity), "GiveSystem: entity does not exist");
    require(LibCooldown.isReady(components, coreEntity), "GiveSystem: entity is in cooldown");
    require(LibCore.checkEnergy(components, coreEntity, TRANSFER_COST), "GiveSystem: not enough energy");

    uint256 baseEntity = LibInventory.getCarriedBy(components, coreEntity);
    require(LibInventory.isCarriedBy(components, _portableEntity, baseEntity), "GiveSystem: not carried by caller");

    Coord memory baseEntityPosition = LibMove.getPosition(components, baseEntity);
    Coord memory targetBaseEntityPosition = LibMove.getPosition(components, _targetBaseEntity);
    require(LibMap.isAdjacent(baseEntityPosition, targetBaseEntityPosition), "GiveSystem: not adjacent");

    LibInventory.addToInventory(components, _targetBaseEntity, _portableEntity);

    LibCore.decreaseEnergy(components, coreEntity, TRANSFER_COST);
  }

  function executeTyped(uint256 _portableEntity, uint256 _targetBaseEntity) public returns (bytes memory) {
    return execute(abi.encode(_portableEntity, _targetBaseEntity));
  }
}
