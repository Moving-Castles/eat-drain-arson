// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.17;

import { QueryFragment, QueryType } from "solecs/interfaces/Query.sol";
import { LibQuery } from "solecs/LibQuery.sol";
import { IWorld } from "solecs/interfaces/IWorld.sol";

import { IUint256Component } from "solecs/interfaces/IUint256Component.sol";
import { getAddressById, addressToEntity } from "solecs/utils.sol";

import { LibUtils } from "../libraries/LibUtils.sol";
import { LibMove } from "../libraries/LibMove.sol";

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
   * Check if two coordinates are adjacent
   *
   * @param _components world components
   * @param _untraversableEntity untraversable enitit ID
   * @param _coordinates position
   */
  function createUntraversable(
    IUint256Component _components,
    uint256 _untraversableEntity,
    Coord memory _coordinates
  ) internal {
    LibMove.makeUntraversable(_components, _untraversableEntity);
    LibMove.setPosition(_components, _untraversableEntity, _coordinates);
  }
}
