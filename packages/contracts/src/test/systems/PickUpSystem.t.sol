// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.17;

import "../MudTest.t.sol";
import { console } from "forge-std/console.sol";
import { addressToEntity } from "solecs/utils.sol";

import { ComponentDevSystem, ID as ComponentDevSystemID } from "../../systems/ComponentDevSystem.sol";
import { PickUpSystem, ID as PickUpSystemID } from "../../systems/PickUpSystem.sol";
import { SpawnSystem, ID as SpawnSystemID } from "../../systems/SpawnSystem.sol";

import { Coord } from "../../components/PositionComponent.sol";
import { Direction } from "../../utils/constants.sol";

import { LibResource } from "../../libraries/LibResource.sol";
import { LibSubstanceBlock } from "../../libraries/LibSubstanceBlock.sol";

contract PickUpSystemTest is MudTest {
  function testPickUp() public {
    setUp();
    SpawnSystem spawnSystem = SpawnSystem(system(SpawnSystemID));
    PickUpSystem pickUpSystem = PickUpSystem(system(PickUpSystemID));

    vm.startPrank(alice);
    spawnSystem.executeTyped();

    // Get base entity
    assertTrue(carriedByComponent.has(addressToEntity(alice)));
    uint256 baseEntity = carriedByComponent.getValue(addressToEntity(alice));
    Coord memory initialPosition = positionComponent.getValue(baseEntity);

    vm.roll(2);

    // Create a portable entity on same tile
    uint256 portableEntity = world.getUniqueEntityId();
    ComponentDevSystem(system(ComponentDevSystemID)).executeTyped(PortableComponentID, portableEntity, abi.encode(1));
    ComponentDevSystem(system(ComponentDevSystemID)).executeTyped(
      PositionComponentID,
      portableEntity,
      abi.encode(initialPosition)
    );

    // Pick it up
    pickUpSystem.executeTyped(portableEntity);

    // portableEntity should be carried by baseEntity
    assertEq(carriedByComponent.getValue(portableEntity), baseEntity);

    // portableEntity should have no position
    assertTrue(!positionComponent.has(portableEntity));

    // Core energy should be INITAL_ENERGY - TRANSFER_COST
    assertEq(energyComponent.getValue(addressToEntity(alice)), gameConfig.initialEnergy - gameConfig.transferCost);

    vm.stopPrank();
  }
}
