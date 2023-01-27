// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.17;

import { QueryFragment, QueryType } from "solecs/interfaces/Query.sol";
import { LibQuery } from "solecs/LibQuery.sol";
import { IWorld } from "solecs/interfaces/IWorld.sol";

import { IUint256Component } from "solecs/interfaces/IUint256Component.sol";
import { getAddressById, addressToEntity } from "solecs/utils.sol";

import { Direction } from "../utils/constants.sol";

import { LibConfig } from "../libraries/LibConfig.sol";
import { GameConfig } from "../components/GameConfigComponent.sol";

import { PositionComponent, ID as PositionComponentID, Coord } from "../components/PositionComponent.sol";
import { AbilityMoveComponent, ID as AbilityMoveComponentID } from "../components/AbilityMoveComponent.sol";
import { UntraversableComponent, ID as UntraversableComponentID } from "../components/UntraversableComponent.sol";

library LibMove {
  /**
   * Get position of entity
   *
   * @param _components World components
   * @param _entity Entity
   * @return coord position of entity
   */
  function getPosition(IUint256Component _components, uint256 _entity) internal view returns (Coord memory) {
    PositionComponent positionComponent = PositionComponent(getAddressById(_components, PositionComponentID));
    return positionComponent.getValue(_entity);
  }

  /**
   * Set position of entity
   *
   * @param _components World components
   * @param _entity Entity
   * @param _coordinates position
   */
  function setPosition(IUint256Component _components, uint256 _entity, Coord memory _coordinates) internal {
    PositionComponent positionComponent = PositionComponent(getAddressById(_components, PositionComponentID));
    positionComponent.set(_entity, _coordinates);
  }

  /**
   * Remove position of entity
   *
   * @param _components World components
   * @param _entity Entity
   */
  function removePosition(IUint256Component _components, uint256 _entity) internal {
    PositionComponent positionComponent = PositionComponent(getAddressById(_components, PositionComponentID));
    positionComponent.remove(_entity);
  }

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
   * Check if position is untraversable
   *
   * @param _components World components
   * @param _coordinates position
   * @return bool is untraversable?
   */
  function isUntraversable(IUint256Component _components, Coord memory _coordinates) internal view returns (bool) {
    UntraversableComponent untraversableComponent = UntraversableComponent(
      getAddressById(_components, UntraversableComponentID)
    );
    PositionComponent positionComponent = PositionComponent(getAddressById(_components, PositionComponentID));

    QueryFragment[] memory fragments = new QueryFragment[](2);
    fragments[0] = QueryFragment(QueryType.HasValue, positionComponent, abi.encode(_coordinates));
    fragments[1] = QueryFragment(QueryType.Has, untraversableComponent, abi.encode(0));

    uint256[] memory results = LibQuery.query(fragments);

    if (results.length > 0) return true;
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

    GameConfig memory gameConfig = LibConfig.getGameConfig(_components);

    if (_direction == Direction.North) {
      if (newPosition.y > 0) newPosition.y -= 1;
    } else if (_direction == Direction.NorthEast) {
      if (newPosition.y > 0) newPosition.y -= 1;
      if (newPosition.x < gameConfig.worldWidth) newPosition.x += 1;
    } else if (_direction == Direction.East) {
      if (newPosition.x < gameConfig.worldWidth) newPosition.x += 1;
    } else if (_direction == Direction.SouthEast) {
      if (newPosition.y < gameConfig.worldHeight) newPosition.y += 1;
      if (newPosition.x < gameConfig.worldWidth) newPosition.x += 1;
    } else if (_direction == Direction.South) {
      if (newPosition.y < gameConfig.worldHeight) newPosition.y += 1;
    } else if (_direction == Direction.SouthWest) {
      if (newPosition.y < gameConfig.worldHeight) newPosition.y += 1;
      if (newPosition.x > 0) newPosition.x -= 1;
    } else if (_direction == Direction.West) {
      if (newPosition.x > 0) newPosition.x -= 1;
    } else if (_direction == Direction.NorthWest) {
      if (newPosition.y > 0) newPosition.y -= 1;
      if (newPosition.x > 0) newPosition.x -= 1;
    }

    require(!isUntraversable(_components, newPosition), "LibMove: untraversable");

    positionComponent.set(_entity, newPosition);
  }
}
