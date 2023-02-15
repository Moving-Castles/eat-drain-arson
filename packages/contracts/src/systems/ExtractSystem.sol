// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;
import "solecs/System.sol";
import { IWorld } from "solecs/interfaces/IWorld.sol";
import { getAddressById, addressToEntity } from "solecs/utils.sol";

import { LibMove } from "../libraries/LibMove.sol";
import { LibCore } from "../libraries/LibCore.sol";
import { LibMap } from "../libraries/LibMap.sol";
import { LibResource } from "../libraries/LibResource.sol";
import { LibSubstanceBlock } from "../libraries/LibSubstanceBlock.sol";
import { LibInventory } from "../libraries/LibInventory.sol";
import { LibAbility } from "../libraries/LibAbility.sol";
import { LibConfig } from "../libraries/LibConfig.sol";

import { GameConfig } from "../components/GameConfigComponent.sol";
import { Coord } from "../components/PositionComponent.sol";

import { ID as AbilityExtractComponentID } from "../components/AbilityExtractComponent.sol";

uint256 constant ID = uint256(keccak256("system.Extract"));

contract ExtractSystem is System {
  constructor(IWorld _world, address _components) System(_world, _components) {}

  function execute(bytes memory arguments) public returns (bytes memory) {
    Coord memory _extractionCoordinates = abi.decode(arguments, (Coord));
    uint256 coreEntity = addressToEntity(msg.sender);

    GameConfig memory gameConfig = LibConfig.getGameConfig(components);

    require(LibCore.isSpawned(components, coreEntity), "ExtractSystem: entity does not exist");
    require(LibCore.isReady(components, coreEntity), "ExtractSystem: entity is in cooldown");
    require(!LibCore.isCommitted(components, coreEntity), "ExtractSystem: entity is committed");
    require(LibCore.checkEnergy(components, coreEntity, gameConfig.extractCost), "ExtractSystem: not enough energy");

    uint256 baseEntity = LibInventory.getCarriedBy(components, coreEntity);

    uint32 abilityCount = LibAbility.checkInventoryForAbilityNumber(components, baseEntity, AbilityExtractComponentID);
    require(abilityCount > 0, "ExtractSystem: no item with AbilityExtract");

    Coord memory baseEntityPosition = LibMove.getPosition(components, baseEntity);
    require(LibMap.isAdjacent(baseEntityPosition, _extractionCoordinates), "ExtractSystem: tile not adjacent");

    /*
     * If there is a Resource entity:
     * – subtract the amount of matter in the resource
     * – create a new substance block with the same amount of matter
     *
     * If there is not (meaning the coordinates have not been extracted):
     * – create resource with the default amount of matter per tile - the requested amount
     * – create a new substance block with the same amount of matter
     */

    uint256 resourceEntity = LibResource.getAtCoordinate(components, _extractionCoordinates);

    // Extract 10 more for each extra "extract organ", capped at default amount per tile
    uint32 matterToExtract = gameConfig.extractCost + (10 * (abilityCount - 1));
    matterToExtract = matterToExtract > gameConfig.matterPerTile ? gameConfig.matterPerTile : matterToExtract;

    if (resourceEntity != 0) {
      uint32 matterInResource = LibResource.getMatter(components, resourceEntity);
      require(matterInResource > 0, "ExtractSystem: tile is empty");
      // Limit extraction to amount available in resource
      matterToExtract = matterToExtract > matterInResource ? matterInResource : matterToExtract;
      LibResource.decreaseMatter(components, resourceEntity, matterToExtract);
      LibSubstanceBlock.create(components, world.getUniqueEntityId(), _extractionCoordinates, matterToExtract);
    } else {
      LibResource.create(
        components,
        world.getUniqueEntityId(),
        _extractionCoordinates,
        gameConfig.matterPerTile - matterToExtract
      );
      LibSubstanceBlock.create(components, world.getUniqueEntityId(), _extractionCoordinates, matterToExtract);
    }

    LibCore.setReadyBlock(components, coreEntity, gameConfig.extractCooldown);
    LibCore.decreaseEnergy(components, coreEntity, gameConfig.extractCost);
  }

  function executeTyped(Coord memory _extractionCoordinates) public returns (bytes memory) {
    return execute(abi.encode(_extractionCoordinates));
  }
}
