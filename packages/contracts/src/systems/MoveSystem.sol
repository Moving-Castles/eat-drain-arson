// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;
import "solecs/System.sol";
import { IWorld } from "solecs/interfaces/IWorld.sol";
import { getAddressById, addressToEntity } from "solecs/utils.sol";

import { Direction } from "../utils/types.sol";
import { STEP_COST } from "../utils/config.sol";

import { LibMove } from "../libraries/LibMove.sol";
import { LibCore } from "../libraries/LibCore.sol";
import { LibCooldown } from "../libraries/LibCooldown.sol";

import { ControlComponent, ID as ControlComponentID } from "../components/ControlComponent.sol";
import { PositionComponent, ID as PositionComponentID, Coord } from "../components/PositionComponent.sol";
import { EnergyComponent, ID as EnergyComponentID } from "../components/EnergyComponent.sol";

uint256 constant ID = uint256(keccak256("system.Move"));

contract MoveSystem is System {
  constructor(IWorld _world, address _components) System(_world, _components) {}

  function execute(bytes memory arguments) public returns (bytes memory) {
    (uint256 _coreEntity, uint32 _direction) = abi.decode(arguments, (uint256, uint32));

    require(LibCooldown.isReady(components, _coreEntity), "in cooldown");
    require(LibCore.subtractEnergy(components, _coreEntity, STEP_COST), "not enough energy");

    uint256 baseEntity = LibCore.getControlledEntity(components, _coreEntity);
    LibMove.step(components, baseEntity, Direction(_direction));

    LibCooldown.setReadyBlock(components, _coreEntity, STEP_COST);
  }

  function executeTyped(uint256 _entity, uint32 _direction) public returns (bytes memory) {
    return execute(abi.encode(_entity, _direction));
  }
}
