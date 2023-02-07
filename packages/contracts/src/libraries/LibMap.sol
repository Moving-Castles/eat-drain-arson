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

import { GameConfig } from "../components/GameConfigComponent.sol";
import { Coord } from "../components/PositionComponent.sol";

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
   * Check if two coordinates are adjacent
   *
   * @param _world world
   * @param _components world components
   * @param _coordinates position
   */
  function createUntraversable(IWorld _world, IUint256Component _components, Coord memory _coordinates) internal {
    GameConfig memory gameConfig = LibConfig.getGameConfig(_components);

    // Create baseEntity
    uint256 baseEntity = _world.getUniqueEntityId();
    LibMove.setPosition(_components, baseEntity, _coordinates);
    LibInventory.setCarryingCapacity(_components, baseEntity, gameConfig.defaultCarryingCapacity * 2);

    // Create untraversable item
    uint256 untraversableEntity = _world.getUniqueEntityId();
    LibMove.makeUntraversable(_components, untraversableEntity);
    LibInventory.makePortable(_components, untraversableEntity);
    LibInventory.addToInventory(_components, baseEntity, untraversableEntity);
  }

  /**
   * Generates random coordinates, within the bounds of the world
   *
   * @param _components world components
   * @return coord random coordinates
   */
  function randomCoordinates(IUint256Component _components) internal view returns (Coord memory) {
    GameConfig memory gameConfig = LibConfig.getGameConfig(_components);

    // We try max 10 times to get an untraversable position, then give up a return a default...
    for (uint256 i = 0; i < 10; i++) {
      int32 x = int32(int256(LibUtils.random(addressToEntity(msg.sender), block.timestamp)) % gameConfig.worldWidth);
      int32 y = int32(int256(LibUtils.random(block.timestamp, block.number)) % gameConfig.worldHeight);

      // Make sure the values are positive
      if (x < 0) x *= -1;
      if (y < 0) y *= -1;

      if (!LibMove.isUntraversable(_components, Coord(x, y))) return Coord(x, y);
    }
    return Coord(2, 4);
  }
}
