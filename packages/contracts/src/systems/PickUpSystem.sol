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

uint256 constant ID = uint256(keccak256("system.PickUp"));

contract PickUpSystem is System {
  constructor(IWorld _world, address _components) System(_world, _components) {}

  function execute(bytes memory arguments) public returns (bytes memory) {
    uint256 _portableEntity = abi.decode(arguments, (uint256));
    uint256 coreEntity = addressToEntity(msg.sender);

    GameConfig memory gameConfig = LibConfig.getGameConfig(components);

    require(LibCore.isSpawned(components, coreEntity), "PickUpSystem: entity does not exist");
    require(LibCooldown.isReady(components, coreEntity), "PickUpSystem: entity is in cooldown");
    require(!LibCore.isCommitted(components, coreEntity), "PickUpSystem: entity is committed");
    require(LibCore.checkEnergy(components, coreEntity, gameConfig.pickUpCost), "PickUpSystem: not enough energy");
    require(LibInventory.isPortable(components, _portableEntity), "PickUpSystem: entity is not portable");

    uint256 baseEntity = LibInventory.getCarriedBy(components, coreEntity);
    Coord memory baseEntityPosition = LibMove.getPosition(components, baseEntity);

    Coord memory portableEntityPosition = LibMove.getPosition(components, _portableEntity);
    require(LibMap.isAdjacent(baseEntityPosition, portableEntityPosition), "PickUpSystem: tile not adjacent");

    LibMove.removePosition(components, _portableEntity);
    LibInventory.addToInventory(components, baseEntity, _portableEntity);

    LibCore.decreaseEnergy(components, coreEntity, gameConfig.pickUpCost);
  }

  function executeTyped(uint256 _portableEntity) public returns (bytes memory) {
    return execute(abi.encode(_portableEntity));
  }
}
