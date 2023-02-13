// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.17;

import { QueryFragment, QueryType } from "solecs/interfaces/Query.sol";
import { LibQuery } from "solecs/LibQuery.sol";
import { IWorld } from "solecs/interfaces/IWorld.sol";

import { LibConfig } from "./LibConfig.sol";

import { GameConfig } from "../components/GameConfigComponent.sol";

import { IUint256Component } from "solecs/interfaces/IUint256Component.sol";
import { getAddressById, addressToEntity } from "solecs/utils.sol";

import { BurnBlockComponent, ID as BurnBlockComponentID } from "../components/BurnBlockComponent.sol";
import { MatterComponent, ID as MatterComponentID } from "../components/MatterComponent.sol";

library LibBurn {
  /**
   * Burn a substance block
   *
   * @param _components World components
   * @param _entity Substanceblock entity
   */
  function burn(IUint256Component _components, uint256 _entity) internal {
    MatterComponent matterComponent = MatterComponent(getAddressById(_components, MatterComponentID));
    BurnBlockComponent burnBlockComponent = BurnBlockComponent(getAddressById(_components, BurnBlockComponentID));
    GameConfig memory gameConfig = LibConfig.getGameConfig(_components);
    burnBlockComponent.set(_entity, block.number + (matterComponent.getValue(_entity) * gameConfig.burnTime));
  }
}
