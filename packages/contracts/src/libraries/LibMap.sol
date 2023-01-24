// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.17;

import { QueryFragment, QueryType } from "solecs/interfaces/Query.sol";
import { LibQuery } from "solecs/LibQuery.sol";
import { IWorld } from "solecs/interfaces/IWorld.sol";

import { IUint256Component } from "solecs/interfaces/IUint256Component.sol";
import { getAddressById, addressToEntity } from "solecs/utils.sol";

import { LibUtils } from "../libraries/LibUtils.sol";
import { LibResource } from "../libraries/LibResource.sol";
import { LibSubstanceBlock } from "../libraries/LibSubstanceBlock.sol";

import { Coord } from "../components/PositionComponent.sol";

library LibMap {
  /**
   * Calculate chebyshev distance
   * https://en.wikipedia.org/wiki/Chebyshev_distance
   *
   * @param _A Coordinate A
   * @param _B Coordinate B
   */
  function chebyshevDistance(Coord memory _A, Coord memory _B) internal pure returns (int32) {
    return LibUtils.max(LibUtils.abs(_A.x - _B.x), LibUtils.abs(_A.y - _B.y));
  }

  /**
   * Check if two coordinates are adjacent
   *
   * @param _A Coordinate A
   * @param _B Coordinate B
   */
  function isAdjacent(Coord memory _A, Coord memory _B) internal pure returns (bool) {
    int32 distance = chebyshevDistance(_A, _B);
    if (distance == 0 || distance == 1) return true;
    return false;
  }
}
