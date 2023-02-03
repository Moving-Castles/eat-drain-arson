// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.17;

import { QueryFragment, QueryType } from "solecs/interfaces/Query.sol";
import { LibQuery } from "solecs/LibQuery.sol";
import { IWorld } from "solecs/interfaces/IWorld.sol";

import { IUint256Component } from "solecs/interfaces/IUint256Component.sol";
import { getAddressById, addressToEntity } from "solecs/utils.sol";

import { LibAbility } from "../libraries/LibAbility.sol";
import { LibMap } from "../libraries/LibMap.sol";
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

    // Repeat until we get get a position that is not untraversable
    while (true) {
      int32 randomX = int32(
        int256(uint256(keccak256(abi.encodePacked(block.timestamp, block.number, msg.sender)))) % 10
      );
      int32 randomY = int32(
        int256(uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty, msg.sender)))) % 10
      );
      // Make sure the values are positive
      if (randomX < 0) randomX *= -1;
      if (randomY < 0) randomY *= -1;
      // randomX += 25;
      // randomY += 25;

      if (!isUntraversable(_components, Coord(randomX, randomY))) {
        positionComponent.set(_entity, Coord(randomX, randomY));
        return;
      }
    }
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
      if (LibAbility.checkInventoryForAbility(_components, results[i], UntraversableComponentID)) return true;
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

  /**
   * Move one step
   *
   * @param _components World components
   * @param _entity Entity to move
   * @param _targetPosition Position to move to
   */
  function step(IUint256Component _components, uint256 _entity, Coord memory _targetPosition) internal {
    PositionComponent positionComponent = PositionComponent(getAddressById(_components, PositionComponentID));
    Coord memory currentPosition = positionComponent.getValue(_entity);

    require(LibMap.isWithinBounds(_components, _targetPosition), "LibMove: out of bounds");
    require(LibMap.isAdjacent(currentPosition, _targetPosition), "LibMove: not adjacent");
    require(!isUntraversable(_components, _targetPosition), "LibMove: untraversable");

    positionComponent.set(_entity, _targetPosition);
  }
}
