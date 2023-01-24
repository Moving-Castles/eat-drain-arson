// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.17;

import "../MudTest.t.sol";
import { console } from "forge-std/console.sol";
import { addressToEntity } from "solecs/utils.sol";
import { STEP_COST, WORLD_HEIGHT, WORLD_WIDTH, INITIAL_ENERGY } from "../../utils/config.sol";
import { MoveSystem, ID as MoveSystemID } from "../../systems/MoveSystem.sol";
import { SpawnSystem, ID as SpawnSystemID } from "../../systems/SpawnSystem.sol";
import { Coord } from "../../components/PositionComponent.sol";
import { Direction } from "../../utils/types.sol";

contract MoveSystemTest is MudTest {
  function testStep() public {
    setUp();

    // --- Spawn core
    vm.startPrank(alice);
    SpawnSystem(system(SpawnSystemID)).executeTyped();
    vm.stopPrank();

    // --- Get base entity
    assertTrue(carriedByComponent.has(addressToEntity(alice)));
    uint256 baseEntity = carriedByComponent.getValue(addressToEntity(alice));
    console.log("___ BASE ENTITY:");
    console.log(baseEntity);

    // --- Initial position
    Coord memory initialPosition = positionComponent.getValue(baseEntity);
    console.log("___ INITIAL POSITION:");
    console.logInt(initialPosition.x);
    console.logInt(initialPosition.y);

    vm.roll(2);

    vm.startPrank(alice);
    MoveSystem(system(MoveSystemID)).executeTyped(uint32(Direction.North));
    vm.stopPrank();

    // --- New position
    Coord memory newPosition = positionComponent.getValue(baseEntity);
    console.log("___ NEW POSITION:");
    console.logInt(newPosition.x);
    console.logInt(newPosition.y);

    // --- ReadyBlock
    uint256 rB = readyBlockComponent.getValue(addressToEntity(alice));
    assertEq(rB, STEP_COST + 2);
    console.log("___READY BLOCK:");
    console.log(rB);

    // --- Energy
    assertEq(energyComponent.getValue(addressToEntity(alice)), INITIAL_ENERGY - STEP_COST);
  }

  function testRevertCooldown() public {
    setUp();

    SpawnSystem spawnSystem = SpawnSystem(system(SpawnSystemID));
    MoveSystem moveSystem = MoveSystem(system(MoveSystemID));

    // --- Spawn core
    vm.startPrank(alice);
    spawnSystem.executeTyped();

    vm.roll(2);

    moveSystem.executeTyped(uint32(Direction.North));

    vm.expectRevert(bytes("MoveSystem: entity is in cooldown"));
    moveSystem.executeTyped(uint32(Direction.South));
    vm.stopPrank();
  }

  function testRevertUnspawned() public {
    setUp();
    MoveSystem moveSystem = MoveSystem(system(MoveSystemID));
    vm.startPrank(alice);
    vm.expectRevert(bytes("MoveSystem: entity does not exist"));
    moveSystem.executeTyped(uint32(Direction.South));
    vm.stopPrank();
  }
}
