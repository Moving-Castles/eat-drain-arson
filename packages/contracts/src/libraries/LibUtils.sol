// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.17;

import { QueryFragment, QueryType } from "solecs/interfaces/Query.sol";
import { LibQuery } from "solecs/LibQuery.sol";
import { IWorld } from "solecs/interfaces/IWorld.sol";

import { IUint256Component } from "solecs/interfaces/IUint256Component.sol";
import { getAddressById, addressToEntity } from "solecs/utils.sol";

library LibUtils {
  /**
   * @notice simple rng calculation
   * @dev     complexity needs to be increased in prod
   * @param   r1  first source of randomness
   * @param   r2  second source of randomness
   * @return  r  random value
   */
  function randomness(uint256 r1, uint256 r2) public view returns (uint256 r) {
    return uint256(keccak256(abi.encodePacked(r1, r2, block.timestamp, blockhash(block.number - 1))));
  }

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
