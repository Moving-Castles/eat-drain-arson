// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.17;

import "../MudTest.t.sol";
import { console } from "forge-std/console.sol";
import { addressToEntity } from "solecs/utils.sol";

import { ComponentDevSystem, ID as ComponentDevSystemID } from "../../systems/ComponentDevSystem.sol";
import { BurnSystem, ID as BurnSystemID } from "../../systems/BurnSystem.sol";
import { SpawnSystem, ID as SpawnSystemID } from "../../systems/SpawnSystem.sol";

import { Coord } from "../../components/PositionComponent.sol";

import { LibResource } from "../../libraries/LibResource.sol";
import { LibInventory } from "../../libraries/LibInventory.sol";
import { LibSubstanceBlock } from "../../libraries/LibSubstanceBlock.sol";

contract BurnSystemTest is MudTest {
  function testBurnInInventory() public {
    setUp();
    SpawnSystem spawnSystem = SpawnSystem(system(SpawnSystemID));
    BurnSystem burnSystem = BurnSystem(system(BurnSystemID));

    vm.startPrank(alice);
    spawnSystem.executeTyped();

    // Get base entity
    uint256 baseEntity = carriedByComponent.getValue(addressToEntity(alice));
    Coord memory initialPosition = positionComponent.getValue(baseEntity);

    vm.roll(2);

    // Create a portable
    uint256 portableEntity = world.getUniqueEntityId();
    ComponentDevSystem(system(ComponentDevSystemID)).executeTyped(PortableComponentID, portableEntity, abi.encode(1));
    ComponentDevSystem(system(ComponentDevSystemID)).executeTyped(MatterComponentID, portableEntity, abi.encode(10));

    // Place in inventory
    ComponentDevSystem(system(ComponentDevSystemID)).executeTyped(
      CarriedByComponentID,
      portableEntity,
      abi.encode(baseEntity)
    );

    // Burn it
    burnSystem.executeTyped(portableEntity);

    // portableEntity should have:
    // burnBlock = currentBlock + (matterInBlock *  burnTime)
    assertTrue(burnBlockComponent.has(portableEntity));
    assertEq(
      burnBlockComponent.getValue(portableEntity),
      block.number + (matterComponent.getValue(portableEntity) * gameConfig.burnTime)
    );

    // Core energy should be INITIAL_ENERGY - BURN_COST
    assertEq(energyComponent.getValue(addressToEntity(alice)), gameConfig.initialEnergy - gameConfig.burnCost);

    vm.stopPrank();
  }

  function testBurnOnMap() public {
    setUp();
    SpawnSystem spawnSystem = SpawnSystem(system(SpawnSystemID));
    BurnSystem burnSystem = BurnSystem(system(BurnSystemID));

    vm.startPrank(alice);
    spawnSystem.executeTyped();

    // Get base entity
    uint256 baseEntity = carriedByComponent.getValue(addressToEntity(alice));
    Coord memory initialPosition = positionComponent.getValue(baseEntity);

    vm.roll(2);

    // Create a portable
    uint256 portableEntity = world.getUniqueEntityId();
    ComponentDevSystem(system(ComponentDevSystemID)).executeTyped(PortableComponentID, portableEntity, abi.encode(1));
    ComponentDevSystem(system(ComponentDevSystemID)).executeTyped(MatterComponentID, portableEntity, abi.encode(10));

    // Place on map
    ComponentDevSystem(system(ComponentDevSystemID)).executeTyped(
      PositionComponentID,
      portableEntity,
      abi.encode(initialPosition)
    );

    // Burn it
    burnSystem.executeTyped(portableEntity);

    // portableEntity should have:
    // burnBlock = currentBlock + (matterInBlock *  burnTime)
    assertTrue(burnBlockComponent.has(portableEntity));
    assertEq(
      burnBlockComponent.getValue(portableEntity),
      block.number + (matterComponent.getValue(portableEntity) * gameConfig.burnTime)
    );

    // Core energy should be INITIAL_ENERGY - BURN_COST
    assertEq(energyComponent.getValue(addressToEntity(alice)), gameConfig.initialEnergy - gameConfig.burnCost);

    vm.stopPrank();
  }

  function testRevertNotAdjacent() public {
    setUp();
    SpawnSystem spawnSystem = SpawnSystem(system(SpawnSystemID));
    BurnSystem burnSystem = BurnSystem(system(BurnSystemID));

    vm.startPrank(alice);
    spawnSystem.executeTyped();

    // Get base entity
    uint256 baseEntity = carriedByComponent.getValue(addressToEntity(alice));
    Coord memory initialPosition = positionComponent.getValue(baseEntity);

    vm.roll(2);

    // Create a portable
    uint256 portableEntity = world.getUniqueEntityId();
    ComponentDevSystem(system(ComponentDevSystemID)).executeTyped(PortableComponentID, portableEntity, abi.encode(1));
    ComponentDevSystem(system(ComponentDevSystemID)).executeTyped(MatterComponentID, portableEntity, abi.encode(10));

    // Place out of reach on map
    ComponentDevSystem(system(ComponentDevSystemID)).executeTyped(
      PositionComponentID,
      portableEntity,
      abi.encode(Coord(initialPosition.x + 2, initialPosition.y))
    );

    // Burn it
    vm.expectRevert(bytes("BurnSystem: not adjacent"));
    burnSystem.executeTyped(portableEntity);

    vm.stopPrank();
  }
}
