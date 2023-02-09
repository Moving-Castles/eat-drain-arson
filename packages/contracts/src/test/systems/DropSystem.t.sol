// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.17;

import "../MudTest.t.sol";
import { console } from "forge-std/console.sol";
import { addressToEntity } from "solecs/utils.sol";

import { ComponentDevSystem, ID as ComponentDevSystemID } from "../../systems/ComponentDevSystem.sol";
import { DropSystem, ID as DropSystemID } from "../../systems/DropSystem.sol";
import { SpawnSystem, ID as SpawnSystemID } from "../../systems/SpawnSystem.sol";

import { Coord } from "../../components/PositionComponent.sol";

import { LibResource } from "../../libraries/LibResource.sol";
import { LibInventory } from "../../libraries/LibInventory.sol";
import { LibSubstanceBlock } from "../../libraries/LibSubstanceBlock.sol";

contract DropSystemTest is MudTest {
  function testDrop() public {
    setUp();
    SpawnSystem spawnSystem = SpawnSystem(system(SpawnSystemID));
    DropSystem dropSystem = DropSystem(system(DropSystemID));

    vm.startPrank(alice);
    spawnSystem.executeTyped();

    // Get base entity
    assertTrue(carriedByComponent.has(addressToEntity(alice)));
    uint256 baseEntity = carriedByComponent.getValue(addressToEntity(alice));
    Coord memory initialPosition = positionComponent.getValue(baseEntity);

    vm.roll(2);

    // Create a portable
    uint256 portableEntity = world.getUniqueEntityId();
    ComponentDevSystem(system(ComponentDevSystemID)).executeTyped(PortableComponentID, portableEntity, abi.encode(1));

    // Place in inventory
    ComponentDevSystem(system(ComponentDevSystemID)).executeTyped(
      CarriedByComponentID,
      portableEntity,
      abi.encode(baseEntity)
    );

    // Drop it
    dropSystem.executeTyped(portableEntity);

    // portableEntity should have position = baseEntity position
    Coord memory droppedPosition = positionComponent.getValue(portableEntity);
    assertEq(droppedPosition.x, initialPosition.x);
    assertEq(droppedPosition.y, initialPosition.y);

    // portableEntity should not have carriedBy
    assertTrue(!carriedByComponent.has(portableEntity));

    // Core energy should be INITIAL_ENERGY - DROP_COST
    assertEq(energyComponent.getValue(addressToEntity(alice)), gameConfig.initialEnergy - gameConfig.dropCost);

    vm.stopPrank();
  }

  function testDropCore() public {
    setUp();
    SpawnSystem spawnSystem = SpawnSystem(system(SpawnSystemID));
    DropSystem dropSystem = DropSystem(system(DropSystemID));

    vm.startPrank(alice);
    spawnSystem.executeTyped();

    // Get base entity
    assertTrue(carriedByComponent.has(addressToEntity(alice)));
    uint256 baseEntity = carriedByComponent.getValue(addressToEntity(alice));
    Coord memory initialPosition = positionComponent.getValue(baseEntity);

    vm.roll(2);

    // Drop your own core
    dropSystem.executeTyped(addressToEntity(alice));

    // Core is in the void
    assertTrue(!positionComponent.has(addressToEntity(alice)));

    // Core should not have carriedBy
    assertTrue(!carriedByComponent.has(addressToEntity(alice)));

    // Core energy should be INITIAL_ENERGY - DROP_COST
    assertEq(energyComponent.getValue(addressToEntity(alice)), gameConfig.initialEnergy - gameConfig.dropCost);

    vm.stopPrank();
  }

  function testEmptyBaseEntityRemoval() public {
    setUp();
    SpawnSystem spawnSystem = SpawnSystem(system(SpawnSystemID));
    DropSystem dropSystem = DropSystem(system(DropSystemID));

    vm.startPrank(alice);
    spawnSystem.executeTyped();

    // Get base entity
    uint256 baseEntity = carriedByComponent.getValue(addressToEntity(alice));
    Coord memory initialPosition = positionComponent.getValue(baseEntity);

    uint256[] memory inventory = LibInventory.getInventory(components, baseEntity);

    vm.roll(2);

    // Drop everything in inventory, except the core
    for (uint256 i; i < inventory.length; i++) {
      if (inventory[i] != addressToEntity(alice)) {
        dropSystem.executeTyped(inventory[i]);
      }
    }

    // Finally, drop the core
    dropSystem.executeTyped(addressToEntity(alice));

    // Base entity should be removed
    assertTrue(!positionComponent.has(baseEntity));
    assertTrue(!carryingCapacityComponent.has(baseEntity));

    vm.stopPrank();
  }
}
