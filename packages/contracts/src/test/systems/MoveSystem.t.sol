// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.0;

import "../MudTest.t.sol";
import { console } from "forge-std/console.sol";
import { STEP_COST, WORLD_HEIGHT, WORLD_WIDTH, INITIAL_RESOURCE, INITIAL_ENERGY } from "../../utils/config.sol";
import { MoveSystem, ID as MoveSystemID } from "../../systems/MoveSystem.sol";
import { SpawnSystem, ID as SpawnSystemID } from "../../systems/SpawnSystem.sol";
import { Coord } from "../../components/PositionComponent.sol";
import { Direction } from "../../utils/types.sol";

contract SpawnSystemTest is MudTest {
  function testExecute() public {
    uint256 coreEntity = 666;

    console.log("___ CORE ENTITY:");
    console.log(coreEntity);

    // --- Spawn
    SpawnSystem(system(SpawnSystemID)).executeTyped(coreEntity);

    // --- Get base entity
    assertTrue(controlComponent.has(coreEntity));
    uint256 baseEntity = controlComponent.getValue(coreEntity);
    console.log("___ BASE ENTITY:");
    console.log(baseEntity);

    // --- Initial position
    Coord memory initialPosition = positionComponent.getValue(baseEntity);
    console.log("___ INITIAL POSITION:");
    console.logInt(initialPosition.x);
    console.logInt(initialPosition.y);

    MoveSystem(system(MoveSystemID)).executeTyped(coreEntity, uint32(Direction.North));

    // --- New position
    Coord memory newPosition = positionComponent.getValue(baseEntity);
    console.log("___ NEW POSITION:");
    console.logInt(newPosition.x);
    console.logInt(newPosition.y);

    // --- ReadyBlock
    uint256 rB = readyBlockComponent.getValue(coreEntity);
    console.log("___READY BLOCK:");
    console.log(rB);

    // --- Energy
    assertEq(energyComponent.getValue(coreEntity), INITIAL_ENERGY - STEP_COST);

    vm.expectRevert(bytes("in cooldown"));
    MoveSystem(system(MoveSystemID)).executeTyped(coreEntity, uint32(Direction.North));
  }
}
