// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;
import "solecs/System.sol";
import { IWorld } from "solecs/interfaces/IWorld.sol";

import { LibConfig } from "../libraries/LibConfig.sol";

import { GameConfig } from "../components/GameConfigComponent.sol";

uint256 constant ID = uint256(keccak256("system.Init"));

contract InitSystem is System {
  constructor(IWorld _world, address _components) System(_world, _components) {}

  function execute(bytes memory arguments) public returns (bytes memory) {
    // @todo restrict access to admin
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
  }

  function executeTyped() public returns (bytes memory) {
    return execute(abi.encode());
  }
}
