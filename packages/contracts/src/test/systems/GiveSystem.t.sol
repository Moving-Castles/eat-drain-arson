// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.17;

import "../MudTest.t.sol";
import { console } from "forge-std/console.sol";
import { addressToEntity } from "solecs/utils.sol";
import { TRANSFER_COST, INITIAL_ENERGY } from "../../utils/config.sol";
import { GiveSystem, ID as GiveSystemID } from "../../systems/GiveSystem.sol";
import { SpawnSystem, ID as SpawnSystemID } from "../../systems/SpawnSystem.sol";
import { Coord } from "../../components/PositionComponent.sol";
import { Direction } from "../../utils/types.sol";

import { LibResource } from "../../libraries/LibResource.sol";
import { LibSubstanceBlock } from "../../libraries/LibSubstanceBlock.sol";

import { ComponentDevSystem, ID as ComponentDevSystemID } from "../../systems/ComponentDevSystem.sol";

contract GiveSystemTest is MudTest {
  function testGive() public {
    setUp();
    SpawnSystem spawnSystem = SpawnSystem(system(SpawnSystemID));
    GiveSystem giveSystem = GiveSystem(system(GiveSystemID));

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

    // Give portableEntity to bob
    vm.startPrank(alice);
    giveSystem.executeTyped(portableEntity, bobBaseEntity);
    vm.stopPrank();

    // portableEntity should be carried by Bob
    assertEq(carriedByComponent.getValue(portableEntity), bobBaseEntity);

    // Core energy should be INITAL_ENERGY - TRANSFER_COST
    assertEq(energyComponent.getValue(addressToEntity(alice)), INITIAL_ENERGY - TRANSFER_COST);
  }
}
