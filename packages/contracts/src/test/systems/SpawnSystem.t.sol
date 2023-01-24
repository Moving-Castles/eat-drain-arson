// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.17;

import "../MudTest.t.sol";
import { console } from "forge-std/console.sol";
import { addressToEntity } from "solecs/utils.sol";
import { WORLD_HEIGHT, WORLD_WIDTH, INITIAL_ENERGY, DEFAULT_CARRYING_CAPACITY } from "../../utils/config.sol";
import { SpawnSystem, ID as SpawnSystemID } from "../../systems/SpawnSystem.sol";
import { Coord } from "../../components/PositionComponent.sol";

contract SpawnSystemTest is MudTest {
  function testSpawn() public {
    setUp();

    // --- Spawn core
    vm.startPrank(alice);
    SpawnSystem(system(SpawnSystemID)).executeTyped();
    vm.stopPrank();

    // --- Energy
    assertEq(energyComponent.getValue(addressToEntity(alice)), INITIAL_ENERGY);

    // --- ReadyBlock
    assertEq(readyBlockComponent.getValue(addressToEntity(alice)), 1);

    // --- CreationBlock
    assertEq(creationBlockComponent.getValue(addressToEntity(alice)), 1);

    // --- Core
    assertTrue(coreComponent.getValue(addressToEntity(alice)));

    // --- Portable
    assertTrue(portableComponent.getValue(addressToEntity(alice)));

    // --- Get base entity
    assertTrue(carriedByComponent.has(addressToEntity(alice)));
    uint256 baseEntity = carriedByComponent.getValue(addressToEntity(alice));

    // --- Position
    Coord memory newPosition = positionComponent.getValue(baseEntity);

    // --- Carrying capacity
    assertEq(carryingCapacityComponent.getValue(baseEntity), DEFAULT_CARRYING_CAPACITY);
  }

  function testRevertRespawn() public {
    setUp();
    SpawnSystem spawnSystem = SpawnSystem(system(SpawnSystemID));
    // Spawn core
    vm.startPrank(alice);
    spawnSystem.executeTyped();
    // Try to respawn
    vm.expectRevert(bytes("SpawnSystem: ID already exists"));
    spawnSystem.executeTyped();
    vm.stopPrank();
  }
}
