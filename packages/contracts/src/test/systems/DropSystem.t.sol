// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.17;

import "../MudTest.t.sol";
import { console } from "forge-std/console.sol";
import { addressToEntity } from "solecs/utils.sol";
import { TRANSFER_COST, INITIAL_ENERGY } from "../../utils/config.sol";
import { DropSystem, ID as DropSystemID } from "../../systems/DropSystem.sol";
import { SpawnSystem, ID as SpawnSystemID } from "../../systems/SpawnSystem.sol";
import { Coord } from "../../components/PositionComponent.sol";
import { Direction } from "../../utils/types.sol";

import { LibResource } from "../../libraries/LibResource.sol";
import { LibSubstanceBlock } from "../../libraries/LibSubstanceBlock.sol";

import { ComponentDevSystem, ID as ComponentDevSystemID } from "../../systems/ComponentDevSystem.sol";

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

    // Core energy should be INITAL_ENERGY - TRANSFER_COST
    assertEq(energyComponent.getValue(addressToEntity(alice)), INITIAL_ENERGY - TRANSFER_COST);

    vm.stopPrank();
  }
}
