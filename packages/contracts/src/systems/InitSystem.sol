// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;
import "solecs/System.sol";
import { IWorld } from "solecs/interfaces/IWorld.sol";

import { LibConfig } from "../libraries/LibConfig.sol";
import { LibMove } from "../libraries/LibMove.sol";

import { Coord } from "../components/PositionComponent.sol";
import { GameConfig } from "../components/GameConfigComponent.sol";

import { GodID } from "../utils/constants.sol";

uint256 constant ID = uint256(keccak256("system.Init"));

contract InitSystem is System {
  constructor(IWorld _world, address _components) System(_world, _components) {}

  function execute(bytes memory arguments) public returns (bytes memory) {
    require(!LibConfig.isInitialized(components), "InitSystem: already initialized");

    GameConfig memory gameConfig = GameConfig({
      worldHeight: 10,
      worldWidth: 10,
      initialEnergy: 100,
      matterPerTile: 100,
      defaultCarryingCapacity: 10,
      moveCost: 10,
      extractCost: 10,
      transferCost: 5
    });
    LibConfig.setGameConfig(components, gameConfig);

    uint256 untraversableEntity = world.getUniqueEntityId();
    LibMove.makeUntraversable(components, untraversableEntity);
    LibMove.setPosition(components, untraversableEntity, Coord(4, 4));
  }

  function executeTyped() public returns (bytes memory) {
    return execute(abi.encode());
  }
}
