// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.17;

import { QueryFragment, QueryType } from "solecs/interfaces/Query.sol";
import { LibQuery } from "solecs/LibQuery.sol";
import { IWorld } from "solecs/interfaces/IWorld.sol";

import { IUint256Component } from "solecs/interfaces/IUint256Component.sol";
import { getAddressById, addressToEntity } from "solecs/utils.sol";

import { PositionComponent, ID as PositionComponentID, Coord } from "../components/PositionComponent.sol";

library LibMove {
  /**
   * @notice  set a random position within bounds
   * @param   _components  world components
   * @param   _entity  entity tot set position for
   */
  function setRandomPosition(IUint256Component _components, uint256 _entity) public {
    PositionComponent positionComponent = PositionComponent(getAddressById(_components, PositionComponentID));
    int32 randomX = int32(int256(uint256(keccak256(abi.encodePacked(block.timestamp, block.number, msg.sender)))) % 10);
    int32 randomY = int32(
      int256(uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty, msg.sender)))) % 10
    );
    // Make sure the values are positive
    if (randomX < 0) randomX *= -1;
    if (randomY < 0) randomY *= -1;
    randomX += 25;
    randomY += 25;
    positionComponent.set(_entity, Coord(randomX, randomY));
  }
}
