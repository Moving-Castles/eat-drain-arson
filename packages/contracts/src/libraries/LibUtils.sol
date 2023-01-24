// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.17;

import { QueryFragment, QueryType } from "solecs/interfaces/Query.sol";
import { LibQuery } from "solecs/LibQuery.sol";
import { IWorld } from "solecs/interfaces/IWorld.sol";

import { IUint256Component } from "solecs/interfaces/IUint256Component.sol";
import { getAddressById, addressToEntity } from "solecs/utils.sol";

import { INITIAL_ENERGY } from "../utils/config.sol";

library LibUtils {
  // @todo: random gen

  /**
   * @dev Returns the largest of two numbers.
   */
  function max(int32 a, int32 b) internal pure returns (int32) {
    return a > b ? a : b;
  }

  /**
   * @dev Returns the smallest of two numbers.
   */
  function min(int32 a, int32 b) internal pure returns (int32) {
    return a < b ? a : b;
  }

  /**
   * @dev Returns the absolute value
   */
  function abs(int32 x) internal pure returns (int32) {
    return x >= 0 ? x : -x;
  }
}
