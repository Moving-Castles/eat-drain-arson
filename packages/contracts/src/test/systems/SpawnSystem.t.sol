// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.17;

import "../MudTest.t.sol";
import { console } from "forge-std/console.sol";
import { addressToEntity } from "solecs/utils.sol";

import { SpawnSystem, ID as SpawnSystemID } from "../../systems/SpawnSystem.sol";
import { Coord } from "../../components/PositionComponent.sol";

import { ID as AbilityMoveComponentID } from "../../components/AbilityMoveComponent.sol";
import { ID as AbilityConsumeComponentID } from "../../components/AbilityConsumeComponent.sol";
import { ID as AbilityExtractComponentID } from "../../components/AbilityExtractComponent.sol";
import { ID as AbilityPlayComponentID } from "../../components/AbilityPlayComponent.sol";
import { ID as AbilityBurnComponentID } from "../../components/AbilityBurnComponent.sol";

import { LibInventory } from "../../libraries/LibInventory.sol";
import { LibAbility } from "../../libraries/LibAbility.sol";
import { LibResource } from "../../libraries/LibResource.sol";

contract SpawnSystemTest is MudTest {
  function testSpawn() public {
    setUp();

    vm.startPrank(alice);
    SpawnSystem(system(SpawnSystemID)).executeTyped();
    vm.stopPrank();

    // Check that the core was spawned correctly
    assertTrue(coreComponent.getValue(addressToEntity(alice)));
    assertTrue(portableComponent.getValue(addressToEntity(alice)));
    assertEq(energyComponent.getValue(addressToEntity(alice)), gameConfig.initialEnergy);
    assertEq(creationBlockComponent.getValue(addressToEntity(alice)), 1);
    assertEq(readyBlockComponent.getValue(addressToEntity(alice)), 1);
    assertTrue(carriedByComponent.has(addressToEntity(alice)));

    // Get base entity
    uint256 baseEntity = carriedByComponent.getValue(addressToEntity(alice));

    // Position
    Coord memory spawnPosition = positionComponent.getValue(baseEntity);
    assertGt(spawnPosition.x, 0);
    assertLt(spawnPosition.x, gameConfig.worldWidth);
    assertGt(spawnPosition.y, 0);
    assertLt(spawnPosition.y, gameConfig.worldHeight);

    // Resource entity with matter = 0 should be created on spawn tile
    uint256 resourceEntity = LibResource.getAtCoordinate(components, spawnPosition);
    assertGt(resourceEntity, 0);
    assertEq(matterComponent.getValue(resourceEntity), 0);

    // Carrying capacity
    assertEq(carryingCapacityComponent.getValue(baseEntity), gameConfig.defaultCarryingCapacity);
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

  function testSpawnInventory() public {
    setUp();

    vm.startPrank(alice);
    SpawnSystem(system(SpawnSystemID)).executeTyped();
    vm.stopPrank();

    // Get base entity
    uint256 baseEntity = carriedByComponent.getValue(addressToEntity(alice));

    // Should have 6 items in inventory:
    // - Core
    // - AbilityMoveItem
    // - AbilityConsumeItem
    // - AbilityExtractItem
    // x AbilityPlayItem
    // x AbilityBurnItem
    uint256[] memory inventory = LibInventory.getInventory(components, baseEntity);
    assertEq(inventory.length, 4);
  }

  function testSpawnAbilities() public {
    setUp();

    vm.startPrank(alice);
    SpawnSystem(system(SpawnSystemID)).executeTyped();
    vm.stopPrank();

    // Get base entity
    uint256 baseEntity = carriedByComponent.getValue(addressToEntity(alice));

    // Should be able to move
    assertEq(LibAbility.checkInventoryForAbility(components, baseEntity, AbilityMoveComponentID), 1);

    // Should be able to consume
    assertEq(LibAbility.checkInventoryForAbility(components, baseEntity, AbilityConsumeComponentID), 1);

    // Should be able to extract
    assertEq(LibAbility.checkInventoryForAbility(components, baseEntity, AbilityExtractComponentID), 1);

    // Should be able to play
    // assertEq(LibAbility.checkInventoryForAbility(components, baseEntity, AbilityPlayComponentID), 1);

    // Should be able to burn
    // assertEq(LibAbility.checkInventoryForAbility(components, baseEntity, AbilityBurnComponentID), 1);
  }
}
