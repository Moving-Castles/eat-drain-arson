// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;
import "solecs/System.sol";
import { IWorld } from "solecs/interfaces/IWorld.sol";
import { getAddressById, addressToEntity } from "solecs/utils.sol";

import { Direction } from "../utils/types.sol";
import { TRANSFER_COST } from "../utils/config.sol";

import { LibMove } from "../libraries/LibMove.sol";
import { LibCore } from "../libraries/LibCore.sol";
import { LibCooldown } from "../libraries/LibCooldown.sol";
import { LibMap } from "../libraries/LibMap.sol";
import { LibInventory } from "../libraries/LibInventory.sol";

import { Coord } from "../components/PositionComponent.sol";

uint256 constant ID = uint256(keccak256("system.Take"));

contract TakeSystem is System {
  constructor(IWorld _world, address _components) System(_world, _components) {}

  function execute(bytes memory arguments) public returns (bytes memory) {
    uint256 _portableEntity = abi.decode(arguments, (uint256));
    uint256 coreEntity = addressToEntity(msg.sender);

    require(LibCore.isSpawned(components, coreEntity), "TakeSystem: entity does not exist");
    require(LibCooldown.isReady(components, coreEntity), "TakeSystem: entity is in cooldown");
    require(LibCore.checkEnergy(components, coreEntity, TRANSFER_COST), "TakeSystem: not enough energy");

    // @todo: make sure the portable is in fact carried
    uint256 targetBaseEntity = LibInventory.getCarriedBy(components, _portableEntity);
    Coord memory targetBaseEntityPosition = LibMove.getPosition(components, targetBaseEntity);

    uint256 baseEntity = LibInventory.getCarriedBy(components, coreEntity);
    Coord memory baseEntityPosition = LibMove.getPosition(components, baseEntity);

    require(LibMap.isAdjacent(baseEntityPosition, targetBaseEntityPosition), "TakeSystem: tile not adjacent");

    LibInventory.addToInventory(components, baseEntity, _portableEntity);

    LibCore.decreaseEnergy(components, coreEntity, TRANSFER_COST);
  }

  function executeTyped(uint256 _portableEntity) public returns (bytes memory) {
    return execute(abi.encode(_portableEntity));
  }
}
