// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.17;

import { QueryFragment, QueryType } from "solecs/interfaces/Query.sol";
import { LibQuery } from "solecs/LibQuery.sol";
import { IWorld } from "solecs/interfaces/IWorld.sol";

import { IUint256Component } from "solecs/interfaces/IUint256Component.sol";
import { getAddressById, addressToEntity } from "solecs/utils.sol";

import { Direction } from "../utils/types.sol";
import { STEP_COST, WORLD_HEIGHT, WORLD_WIDTH } from "../utils/config.sol";

import { PositionComponent, ID as PositionComponentID, Coord } from "../components/PositionComponent.sol";

library LibMove {
  /**
   * Set a random position within bounds
   *
   * @param _components World components
   * @param _entity Entity to set position for
   */
  function setRandomPosition(IUint256Component _components, uint256 _entity) internal {
    PositionComponent positionComponent = PositionComponent(getAddressById(_components, PositionComponentID));
    int32 randomX = int32(int256(uint256(keccak256(abi.encodePacked(block.timestamp, block.number, msg.sender)))) % 10);
    int32 randomY = int32(
      int256(uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty, msg.sender)))) % 10
    );
    // Make sure the values are positive
    if (randomX < 0) randomX *= -1;
    if (randomY < 0) randomY *= -1;
    // randomX += 25;
    // randomY += 25;
    positionComponent.set(_entity, Coord(randomX, randomY));
  }

  /**
   * Move one step
   *
   * @param _components World components
   * @param _entity Entity to move
   * @param _direction Direction to move
   */
  function step(IUint256Component _components, uint256 _entity, Direction _direction) internal {
    PositionComponent positionComponent = PositionComponent(getAddressById(_components, PositionComponentID));
    Coord memory newPosition = positionComponent.getValue(_entity);

    // if (_direction == Direction.North) {
    //   if (newPosition.y > 0) newPosition.y -= 1;
    // } else if (_direction == Direction.NorthEast) {
    //   if (newPosition.y > 0) newPosition.y -= 1;
    //   if (newPosition.x < WORLD_WIDTH) newPosition.x += 1;
    // } else if (_direction == Direction.East) {
    //   if (newPosition.x < WORLD_WIDTH) newPosition.x += 1;
    // } else if (_direction == Direction.SouthEast) {
    //   if (newPosition.y < WORLD_HEIGHT) newPosition.y += 1;
    //   if (newPosition.x < WORLD_WIDTH) newPosition.x += 1;
    // } else if (_direction == Direction.South) {
    //   if (newPosition.y < WORLD_HEIGHT) newPosition.y += 1;
    // } else if (_direction == Direction.SouthWest) {
    //   if (newPosition.y < WORLD_HEIGHT) newPosition.y += 1;
    //   if (newPosition.x > 0) newPosition.x -= 1;
    // } else if (_direction == Direction.West) {
    //   if (newPosition.x > 0) newPosition.x -= 1;
    // } else if (_direction == Direction.NorthWest) {
    //   if (newPosition.y > 0) newPosition.y -= 1;
    //   if (newPosition.x > 0) newPosition.x -= 1;
    // }

    if (_direction == Direction.North) {
      if (newPosition.y > 0) newPosition.y -= 1;
    } else if (_direction == Direction.NorthEast) {
      if (newPosition.y > 0) newPosition.y -= 1;
      if (newPosition.x < WORLD_WIDTH) newPosition.x += 1;
    } else if (_direction == Direction.East) {
      if (newPosition.x < WORLD_WIDTH) newPosition.x += 1;
    } else if (_direction == Direction.SouthEast) {
      if (newPosition.y < WORLD_HEIGHT) newPosition.y += 1;
      if (newPosition.x < WORLD_WIDTH) newPosition.x += 1;
    } else if (_direction == Direction.South) {
      if (newPosition.y < WORLD_HEIGHT) newPosition.y += 1;
    } else if (_direction == Direction.SouthWest) {
      if (newPosition.y < WORLD_HEIGHT) newPosition.y += 1;
      if (newPosition.x > 0) newPosition.x -= 1;
    } else if (_direction == Direction.West) {
      if (newPosition.x > 0) newPosition.x -= 1;
    } else if (_direction == Direction.NorthWest) {
      if (newPosition.y > 0) newPosition.y -= 1;
      if (newPosition.x > 0) newPosition.x -= 1;
    }

    positionComponent.set(_entity, newPosition);
  }
}
