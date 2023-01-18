// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.17;

import { QueryFragment, QueryType } from "solecs/interfaces/Query.sol";
import { LibQuery } from "solecs/LibQuery.sol";
import { IWorld } from "solecs/interfaces/IWorld.sol";

import { IUint256Component } from "solecs/interfaces/IUint256Component.sol";
import { getAddressById, addressToEntity } from "solecs/utils.sol";

import { ReadyBlockComponent, ID as ReadyBlockComponentID } from "../components/ReadyBlockComponent.sol";

library LibCooldown {
  /**
   * Set the ready block for entity
   *
   * @param _components World components
   * @param _entity Entity
   * @param _period How many block to add
   */
  function setReadyBlock(IUint256Component _components, uint256 _entity, uint256 _period) internal {
    ReadyBlockComponent readyBlockComponent = ReadyBlockComponent(getAddressById(_components, ReadyBlockComponentID));
    readyBlockComponent.set(_entity, block.number + _period);
  }

  /**
   * Check if the entity's block is passed and it is allowed to act
   *
   * @param _components World components
   * @param _entity Entity
   * @return boolean False if still in cooldown
   */
  function isReady(IUint256Component _components, uint256 _entity) internal view returns (bool) {
    ReadyBlockComponent readyBlockComponent = ReadyBlockComponent(getAddressById(_components, ReadyBlockComponentID));
    return readyBlockComponent.getValue(_entity) >= block.number ? false : true;
  }
}
