// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.17;

import "../MudTest.t.sol";
import { console } from "forge-std/console.sol";
import { addressToEntity } from "solecs/utils.sol";

import { ComponentDevSystem, ID as ComponentDevSystemID } from "../../systems/ComponentDevSystem.sol";
import { TransferSystem, ID as TransferSystemID } from "../../systems/TransferSystem.sol";
import { SpawnSystem, ID as SpawnSystemID } from "../../systems/SpawnSystem.sol";

import { Coord } from "../../components/PositionComponent.sol";

import { LibResource } from "../../libraries/LibResource.sol";
import { LibSubstanceBlock } from "../../libraries/LibSubstanceBlock.sol";

contract TransferSystemTest is MudTest {
  function testTransfer() public {
    setUp();
    SpawnSystem spawnSystem = SpawnSystem(system(SpawnSystemID));
    TransferSystem transferSystem = TransferSystem(system(TransferSystemID));

    vm.startPrank(alice);
    spawnSystem.executeTyped();
    vm.stopPrank();

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

    // Spawn Bob
    vm.startPrank(bob);
    spawnSystem.executeTyped();
    vm.stopPrank();

    // Get bob's base entity
    uint256 bobBaseEntity = carriedByComponent.getValue(addressToEntity(bob));

    // Move bob to same position as Alice
    ComponentDevSystem(system(ComponentDevSystemID)).executeTyped(
      PositionComponentID,
      bobBaseEntity,
      abi.encode(initialPosition)
    );

    // Transfer portableEntity to bob
    vm.startPrank(alice);
    transferSystem.executeTyped(portableEntity, bobBaseEntity);
    vm.stopPrank();

    // portableEntity should be carried by Bob
    assertEq(carriedByComponent.getValue(portableEntity), bobBaseEntity);

    // Core energy should be INITAL_ENERGY - TRANSFER_COST
    assertEq(energyComponent.getValue(addressToEntity(alice)), gameConfig.initialEnergy - gameConfig.transferCost);
  }
}
