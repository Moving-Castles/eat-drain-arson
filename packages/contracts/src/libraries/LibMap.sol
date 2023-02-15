// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.17;

import { QueryFragment, QueryType } from "solecs/interfaces/Query.sol";
import { LibQuery } from "solecs/LibQuery.sol";
import { IWorld } from "solecs/interfaces/IWorld.sol";

import { IUint256Component } from "solecs/interfaces/IUint256Component.sol";
import { getAddressById, addressToEntity } from "solecs/utils.sol";

import { LibConfig } from "../libraries/LibConfig.sol";
import { LibUtils } from "../libraries/LibUtils.sol";
import { LibMove } from "../libraries/LibMove.sol";
import { LibInventory } from "../libraries/LibInventory.sol";
import { LibResource } from "../libraries/LibResource.sol";
import { LibAbility } from "../libraries/LibAbility.sol";

import { GameConfig } from "../components/GameConfigComponent.sol";
import { Coord } from "../components/PositionComponent.sol";

import { PositionComponent, ID as PositionComponentID, Coord } from "../components/PositionComponent.sol";
import { UntraversableComponent, ID as UntraversableComponentID } from "../components/UntraversableComponent.sol";

library LibMap {
  /**
   * Calculate chebyshev distance
   * https://en.wikipedia.org/wiki/Chebyshev_distance
   *
   * @param _A Coordinate A
   * @param _B Coordinate B
   * @return bool
   */
  function chebyshevDistance(Coord memory _A, Coord memory _B) internal pure returns (int32) {
    return LibUtils.max(LibUtils.abs(_A.x - _B.x), LibUtils.abs(_A.y - _B.y));
  }

  /**
   * Check if two coordinates are adjacent
   *
   * @param _A Coordinate A
   * @param _B Coordinate B
   * @return bool
   */
  function isAdjacent(Coord memory _A, Coord memory _B) internal pure returns (bool) {
    int32 distance = chebyshevDistance(_A, _B);
    if (distance == 0 || distance == 1) return true;
    return false;
  }

  /**
   * Check if within the bounds of the world
   *
   * @param _components world components
   * @param _coordinates position
   * @return bool
   */
  function isWithinBounds(IUint256Component _components, Coord memory _coordinates) internal view returns (bool) {
    GameConfig memory gameConfig = LibConfig.getGameConfig(_components);
    if (_coordinates.x < 0) return false;
    if (_coordinates.x > gameConfig.worldWidth - 1) return false;
    if (_coordinates.y < 0) return false;
    if (_coordinates.y > gameConfig.worldHeight - 1) return false;
    return true;
  }

  /**
   * Generates random coordinates, within the bounds of the world
   *
   * @param _components world components
   * @return coord random coordinates
   */
  function randomCoordinates(IUint256Component _components) internal view returns (Coord memory) {
    GameConfig memory gameConfig = LibConfig.getGameConfig(_components);

    int32 x = int32(int256(LibUtils.random(addressToEntity(msg.sender), block.timestamp)) % gameConfig.worldWidth);
    int32 y = int32(int256(LibUtils.random(block.timestamp, block.number)) % gameConfig.worldHeight);

    // Make sure the values are positive
    if (x < 0) x *= -1;
    if (y < 0) y *= -1;

    return Coord(x, y);
  }

  /**
   * Find a valid spawn location
   *
   * @param _components world components
   * @return coord spawn position
   */
  function getSpawnPosition(IUint256Component _components) internal view returns (Coord memory) {
    // We try max 20 times...
    for (uint32 i = 0; i < 20; i++) {
      Coord memory spawnPosition = randomCoordinates(_components);
      // Has to be traversable and not have a resource entity on it
      if (
        isUntraversable(_components, spawnPosition) == false &&
        LibResource.getAtCoordinate(_components, spawnPosition) == 0
      ) {
        return spawnPosition;
      }
    }
    // @hack: should check conclusively if there is an open spawn position above, and deny spawn if not
    return Coord(2, 4);
  }

  /**
   * Create an untraversable entity at coordinates
   *
   * @param _world world
   * @param _components world components
   * @param _coordinates position
   * @return entity base entity containing the untraversable item
   */
  function createUntraversable(
    IWorld _world,
    IUint256Component _components,
    Coord memory _coordinates
  ) internal returns (uint256) {
    GameConfig memory gameConfig = LibConfig.getGameConfig(_components);

    // Create baseEntity
    uint256 baseEntity = _world.getUniqueEntityId();
    LibMove.setPosition(_components, baseEntity, _coordinates);
    LibInventory.setCarryingCapacity(_components, baseEntity, gameConfig.defaultCarryingCapacity * 2);

    // Create untraversable item
    uint256 untraversableEntity = _world.getUniqueEntityId();
    makeUntraversable(_components, untraversableEntity);
    LibInventory.makePortable(_components, untraversableEntity);
    LibInventory.addToInventory(_components, baseEntity, untraversableEntity);

    return baseEntity;
  }

  /**
   * Check if position is untraversable
   *
   * @param _components World components
   * @param _coordinates position
   * @return bool is untraversable?
   */
  function isUntraversable(IUint256Component _components, Coord memory _coordinates) internal view returns (bool) {
    PositionComponent positionComponent = PositionComponent(getAddressById(_components, PositionComponentID));

    QueryFragment[] memory fragments = new QueryFragment[](1);
    fragments[0] = QueryFragment(QueryType.HasValue, positionComponent, abi.encode(_coordinates));
    uint256[] memory results = LibQuery.query(fragments);

    for (uint256 i; i < results.length; i++) {
      if (LibAbility.checkInventoryForAbility(_components, results[i], UntraversableComponentID) > 0) return true;
    }

    return false;
  }

  /**
   * Make untraversable
   *
   * @param _components World components
   * @param _entity entity
   */
  function makeUntraversable(IUint256Component _components, uint256 _entity) internal {
    UntraversableComponent untraversableComponent = UntraversableComponent(
      getAddressById(_components, UntraversableComponentID)
    );
    untraversableComponent.set(_entity);
  }
}
