// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;
import "solecs/System.sol";
import { IWorld } from "solecs/interfaces/IWorld.sol";
import { getAddressById, addressToEntity } from "solecs/utils.sol";

import { Coord } from "../components/PositionComponent.sol";

import { EXTRACT_COST, MATTER_PER_TILE } from "../utils/config.sol";

import { LibMove } from "../libraries/LibMove.sol";
import { LibCore } from "../libraries/LibCore.sol";
import { LibCooldown } from "../libraries/LibCooldown.sol";
import { LibMap } from "../libraries/LibMap.sol";
import { LibResource } from "../libraries/LibResource.sol";
import { LibSubstanceBlock } from "../libraries/LibSubstanceBlock.sol";
import { LibInventory } from "../libraries/LibInventory.sol";
import { LibAbility } from "../libraries/LibAbility.sol";

import { ID as AbilityExtractComponentID } from "../components/AbilityExtractComponent.sol";

uint256 constant ID = uint256(keccak256("system.Extract"));

contract ExtractSystem is System {
  constructor(IWorld _world, address _components) System(_world, _components) {}

  function execute(bytes memory arguments) public returns (bytes memory) {
    Coord memory _extractionCoordinates = abi.decode(arguments, (Coord));
    uint256 coreEntity = addressToEntity(msg.sender);

    require(LibCore.isSpawned(components, coreEntity), "ExtractSystem: entity does not exist");
    require(LibCooldown.isReady(components, coreEntity), "ExtractSystem: entity is in cooldown");
    require(LibCore.checkEnergy(components, coreEntity, EXTRACT_COST), "ExtractSystem: not enough energy");

    uint256 baseEntity = LibInventory.getCarriedBy(components, coreEntity);

    require(
      LibAbility.checkInventoryForAbility(components, baseEntity, AbilityExtractComponentID),
      "ExtractSystem: no item with AbilityExtract"
    );

    Coord memory baseEntityPosition = LibMove.getPosition(components, baseEntity);
    require(LibMap.isAdjacent(baseEntityPosition, _extractionCoordinates), "ExtractSystem: tile not adjacent");

    /*
     * If there is a Resource entity:
     * – check that there is at least EXTRACT_COST matter
     * – decrease the matter balance of the resource block by EXTRACT_COST
     * – create substanceblock with  EXTRACT_COST matter
     *
     * If there is not (meaning the coordinates have not been extracted):
     * – create resource with MATTER_PER_TILE - EXTRACT_COST matter
     * – create substanceblock with  EXTRACT_COST matter
     */

    uint256 resourceEntity = LibResource.getAtCoordinate(components, _extractionCoordinates);

    if (resourceEntity != 0) {
      require(LibResource.checkMatter(components, resourceEntity, EXTRACT_COST), "ExtractSystem: not enough matter");
      LibResource.decreaseMatter(components, resourceEntity, EXTRACT_COST);
      LibSubstanceBlock.spawn(components, world.getUniqueEntityId(), _extractionCoordinates, EXTRACT_COST);
    } else {
      LibResource.spawn(components, world.getUniqueEntityId(), _extractionCoordinates, MATTER_PER_TILE - EXTRACT_COST);
      LibSubstanceBlock.spawn(components, world.getUniqueEntityId(), _extractionCoordinates, EXTRACT_COST);
    }

    LibCooldown.setReadyBlock(components, coreEntity, EXTRACT_COST);
    LibCore.decreaseEnergy(components, coreEntity, EXTRACT_COST);
  }

  function executeTyped(Coord memory _extractionCoordinates) public returns (bytes memory) {
    return execute(abi.encode(_extractionCoordinates));
  }
}
