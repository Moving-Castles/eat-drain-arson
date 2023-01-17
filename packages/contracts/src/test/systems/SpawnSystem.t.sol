// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.0;

import "../MudTest.t.sol";
import { console } from "forge-std/console.sol";
import { WORLD_HEIGHT, WORLD_WIDTH, INITIAL_RESOURCE, INITIAL_ENERGY } from "../../utils/config.sol";
import { SpawnSystem, ID as SpawnSystemID } from "../../systems/SpawnSystem.sol";
import { Coord } from "../../components/PositionComponent.sol";

contract SpawnSystemTest is MudTest {
  function testExecute() public {
    uint256 coreEntity = 666;

    console.log("___ CORE ENTITY:");
    console.log(coreEntity);

    // --- Spawn core
    SpawnSystem(system(SpawnSystemID)).executeTyped(coreEntity);

    // --- Energy
    assertEq(energyComponent.getValue(coreEntity), INITIAL_ENERGY);

    // --- ReadyBlock
    assertEq(readyBlockComponent.getValue(coreEntity), 1);

    // --- CreationBlock
    assertEq(creationBlockComponent.getValue(coreEntity), 1);

    // // --- Portable
    assertTrue(portableComponent.getValue(coreEntity));

    // // --- Control
    assertTrue(controlComponent.has(coreEntity));
    uint256 baseEntity = controlComponent.getValue(coreEntity);
    console.log("___ BASE ENTITY:");
    console.log(baseEntity);

    // --- Position
    Coord memory newPosition = positionComponent.getValue(baseEntity);

    // --- Inventory
    assertTrue(inventoryComponent.has(baseEntity));
    uint256[] memory inventory = inventoryComponent.getValue(baseEntity);
    assertEq(inventory.length, 1);
    assertEq(inventory[0], coreEntity);
    for (uint256 i = 0; i < inventory.length; i++) {
      console.log("___ INVENTORY:");
      console.log(inventory[i]);
    }
  }
}
