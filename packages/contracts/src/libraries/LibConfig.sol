// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.17;

import { QueryFragment, QueryType } from "solecs/interfaces/Query.sol";
import { LibQuery } from "solecs/LibQuery.sol";
import { IWorld } from "solecs/interfaces/IWorld.sol";

import { IUint256Component } from "solecs/interfaces/IUint256Component.sol";
import { getAddressById, addressToEntity } from "solecs/utils.sol";

import { GodID } from "../utils/constants.sol";

import { GameConfigComponent, ID as GameConfigComponentID, GameConfig } from "../components/GameConfigComponent.sol";

library LibConfig {
  /**
   * Set game config
   *
   * @param _components World components
   * @param _gameConfig game config
   */
  function setGameConfig(IUint256Component _components, GameConfig memory _gameConfig) internal {
    GameConfigComponent gameConfigComponent = GameConfigComponent(getAddressById(_components, GameConfigComponentID));
    gameConfigComponent.set(GodID, _gameConfig);
  }

  /**
   * Get game config
   *
   * @param _components World components
   * @return gameConfig game config
   */
  function getGameConfig(IUint256Component _components) internal view returns (GameConfig memory) {
    GameConfigComponent gameConfigComponent = GameConfigComponent(getAddressById(_components, GameConfigComponentID));
    return gameConfigComponent.getValue(GodID);
  }
}
