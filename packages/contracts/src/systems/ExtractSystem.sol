// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;
import "solecs/System.sol";
import { IWorld } from "solecs/interfaces/IWorld.sol";
import { getAddressById, addressToEntity } from "solecs/utils.sol";

import { LibMove } from "../libraries/LibMove.sol";
import { LibCore } from "../libraries/LibCore.sol";
import { LibCooldown } from "../libraries/LibCooldown.sol";
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
    require(LibCooldown.isReady(components, coreEntity), "ExtractSystem: entity is in cooldown");
    require(LibCore.checkEnergy(components, coreEntity, gameConfig.extractCost), "ExtractSystem: not enough energy");

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
      require(
        LibResource.checkMatter(components, resourceEntity, gameConfig.extractCost),
        "ExtractSystem: not enough matter"
      );
      LibResource.decreaseMatter(components, resourceEntity, gameConfig.extractCost);
      LibSubstanceBlock.create(components, world.getUniqueEntityId(), _extractionCoordinates, gameConfig.extractCost);
    } else {
      LibResource.create(
        components,
        world.getUniqueEntityId(),
        _extractionCoordinates,
        gameConfig.matterPerTile - gameConfig.extractCost
      );
      LibSubstanceBlock.create(components, world.getUniqueEntityId(), _extractionCoordinates, gameConfig.extractCost);
    }

    LibCooldown.setReadyBlock(components, coreEntity, gameConfig.extractCooldown);
    LibCore.decreaseEnergy(components, coreEntity, gameConfig.extractCost);
  }

  function executeTyped(Coord memory _extractionCoordinates) public returns (bytes memory) {
    return execute(abi.encode(_extractionCoordinates));
  }
}
