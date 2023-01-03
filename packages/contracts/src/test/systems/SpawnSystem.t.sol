// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.0;

import "../MudTest.t.sol";
import { console } from "forge-std/console.sol";
import { EntityType } from "../../types.sol";
import { WORLD_HEIGHT, WORLD_WIDTH, INITIAL_RESOURCE, INITIAL_ENERGY } from "../../config.sol";
import { SpawnSystem, ID as SpawnSystemID } from "../../systems/SpawnSystem.sol";
import { Coord } from "../../components/PositionComponent.sol";
import { Stats } from "../../components/StatsComponent.sol";

contract SpawnSystemTest is MudTest {
  function testExecute() public {
    uint256 entity = 1;

    // Spawn player
    SpawnSystem(system(SpawnSystemID)).executeTyped(entity);

    // --- Seed
    uint256 seed = seedComponent.getValue(entity);
    console.log(seed);
    assertGt(seed, 0);

    // --- Energy
    assertEq(energyComponent.getValue(entity), INITIAL_ENERGY);

    // --- Position
    Coord memory newPosition = positionComponent.getValue(entity);
    // X between 0 and WORLD_WIDTH
    assertGt(newPosition.x, 24);
    assertLt(newPosition.x, 36);
    // Y between 0 and WORLD_HEIGHT
    assertGt(newPosition.y, 24);
    assertLt(newPosition.y, 36);

    console.logInt(newPosition.x);
    console.logInt(newPosition.y);

    // --- Resource
    assertEq(resourceComponent.getValue(entity), INITIAL_RESOURCE);

    // --- Player entity type
    assertEq(entityTypeComponent.getValue(entity), uint32(EntityType.Player));

    // --- Cooldown
    assertEq(coolDownComponent.getValue(entity), 0);

    // --- Birth
    assertEq(birthComponent.getValue(entity), 1);

    // --- Stats
    Stats memory initialStats = statsComponent.getValue(entity);
    assertEq(initialStats.traveled, 0);
    assertEq(initialStats.gathered, 0);
    assertEq(initialStats.burnt, 0);
    assertEq(initialStats.eaten, 0);
    assertEq(initialStats.played, 0);
  }
}
