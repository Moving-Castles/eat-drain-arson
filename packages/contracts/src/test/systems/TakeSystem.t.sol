// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.17;

import "../MudTest.t.sol";
import { console } from "forge-std/console.sol";
import { addressToEntity } from "solecs/utils.sol";
import { TRANSFER_COST, INITIAL_ENERGY } from "../../utils/config.sol";
import { TakeSystem, ID as TakeSystemID } from "../../systems/TakeSystem.sol";
import { SpawnSystem, ID as SpawnSystemID } from "../../systems/SpawnSystem.sol";
import { Coord } from "../../components/PositionComponent.sol";
import { Direction } from "../../utils/types.sol";

import { LibResource } from "../../libraries/LibResource.sol";
import { LibSubstanceBlock } from "../../libraries/LibSubstanceBlock.sol";

import { ComponentDevSystem, ID as ComponentDevSystemID } from "../../systems/ComponentDevSystem.sol";

contract TakeSystemTest is MudTest {
  function testTake() public {
    setUp();
    SpawnSystem spawnSystem = SpawnSystem(system(SpawnSystemID));
    TakeSystem takeSystem = TakeSystem(system(TakeSystemID));

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

    // Spawn Bob
    vm.startPrank(bob);
    spawnSystem.executeTyped();
    vm.stopPrank();

    // Get bob's base entity
    uint256 bobBaseEntity = carriedByComponent.getValue(addressToEntity(bob));

    // Place portable in Bob's inventory
    ComponentDevSystem(system(ComponentDevSystemID)).executeTyped(
      CarriedByComponentID,
      portableEntity,
      abi.encode(bobBaseEntity)
    );

    // Move bob
    ComponentDevSystem(system(ComponentDevSystemID)).executeTyped(
      PositionComponentID,
      bobBaseEntity,
      abi.encode(initialPosition)
    );

    // Take the portableEntity
    vm.startPrank(alice);
    takeSystem.executeTyped(portableEntity);
    vm.stopPrank();

    // portableEntity should be carried by Alice
    assertEq(carriedByComponent.getValue(portableEntity), baseEntity);

    // Core energy should be INITAL_ENERGY - TRANSFER_COST
    assertEq(energyComponent.getValue(addressToEntity(alice)), INITIAL_ENERGY - TRANSFER_COST);
  }
}
