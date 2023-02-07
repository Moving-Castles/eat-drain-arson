// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.17;

import "../MudTest.t.sol";
import { console } from "forge-std/console.sol";
import { addressToEntity } from "solecs/utils.sol";

import { ComponentDevSystem, ID as ComponentDevSystemID } from "../../systems/ComponentDevSystem.sol";
import { MoveSystem, ID as MoveSystemID } from "../../systems/MoveSystem.sol";
import { SpawnSystem, ID as SpawnSystemID } from "../../systems/SpawnSystem.sol";

import { LibMove } from "../../libraries/LibMove.sol";
import { LibInventory } from "../../libraries/LibInventory.sol";

import { Coord } from "../../components/PositionComponent.sol";

contract MoveSystemTest is MudTest {
  function testStep() public {
    setUp();

    vm.startPrank(alice);
    SpawnSystem(system(SpawnSystemID)).executeTyped();
    vm.stopPrank();

    // Get base entity
    assertTrue(carriedByComponent.has(addressToEntity(alice)));
    uint256 baseEntity = carriedByComponent.getValue(addressToEntity(alice));

    Coord memory initialPosition = positionComponent.getValue(baseEntity);

    vm.roll(2);

    Coord memory targetPosition = Coord(
      initialPosition.x < gameConfig.worldWidth - 2 ? initialPosition.x + 1 : initialPosition.x - 1,
      initialPosition.y
    );

    vm.startPrank(alice);
    MoveSystem(system(MoveSystemID)).executeTyped(targetPosition);
    vm.stopPrank();

    // --- New position
    Coord memory newPosition = positionComponent.getValue(baseEntity);
    assertEq(newPosition.x, targetPosition.x);
    assertEq(newPosition.y, targetPosition.y);

    // --- ReadyBlock
    uint256 rB = readyBlockComponent.getValue(addressToEntity(alice));
    assertEq(rB, gameConfig.moveCooldown + 2);

    // --- Energy
    assertEq(energyComponent.getValue(addressToEntity(alice)), gameConfig.initialEnergy - gameConfig.moveCost);
  }

  function testRevertUntraversable() public {
    setUp();

    SpawnSystem spawnSystem = SpawnSystem(system(SpawnSystemID));
    MoveSystem moveSystem = MoveSystem(system(MoveSystemID));

    // --- Spawn core
    vm.startPrank(alice);
    spawnSystem.executeTyped();

    vm.roll(2);

    uint256 baseEntity = carriedByComponent.getValue(addressToEntity(alice));

    Coord memory initialPosition = positionComponent.getValue(baseEntity);

    Coord memory targetPosition = Coord(
      initialPosition.x < gameConfig.worldWidth - 2 ? initialPosition.x + 1 : initialPosition.x - 1,
      initialPosition.y
    );

    // Create a base entity at our target position
    uint256 untraversableBaseEntity = world.getUniqueEntityId();
    ComponentDevSystem(system(ComponentDevSystemID)).executeTyped(
      CarryingCapacityComponentID,
      untraversableBaseEntity,
      abi.encode(10)
    );
    ComponentDevSystem(system(ComponentDevSystemID)).executeTyped(
      PositionComponentID,
      untraversableBaseEntity,
      abi.encode(targetPosition)
    );

    // Create an untraversable portable and place it in the inventory
    uint256 portableEntity = world.getUniqueEntityId();
    ComponentDevSystem(system(ComponentDevSystemID)).executeTyped(PortableComponentID, portableEntity, abi.encode(1));
    ComponentDevSystem(system(ComponentDevSystemID)).executeTyped(
      UntraversableComponentID,
      portableEntity,
      abi.encode(1)
    );
    ComponentDevSystem(system(ComponentDevSystemID)).executeTyped(
      CarriedByComponentID,
      portableEntity,
      abi.encode(untraversableBaseEntity)
    );

    vm.expectRevert(bytes("LibMove: untraversable"));
    moveSystem.executeTyped(targetPosition);
  }

  function testRevertCooldown() public {
    setUp();

    SpawnSystem spawnSystem = SpawnSystem(system(SpawnSystemID));
    MoveSystem moveSystem = MoveSystem(system(MoveSystemID));

    // --- Spawn core
    vm.startPrank(alice);
    spawnSystem.executeTyped();

    vm.roll(2);

    uint256 baseEntity = carriedByComponent.getValue(addressToEntity(alice));

    Coord memory initialPosition = positionComponent.getValue(baseEntity);

    MoveSystem(system(MoveSystemID)).executeTyped(
      Coord(
        initialPosition.x < gameConfig.worldWidth - 2 ? initialPosition.x + 1 : initialPosition.x - 1,
        initialPosition.y
      )
    );

    vm.expectRevert(bytes("MoveSystem: entity is in cooldown"));
    moveSystem.executeTyped(Coord(0, 0));
    vm.stopPrank();
  }

  function testRevertUnspawned() public {
    setUp();
    MoveSystem moveSystem = MoveSystem(system(MoveSystemID));
    vm.startPrank(alice);
    vm.expectRevert(bytes("MoveSystem: entity does not exist"));
    moveSystem.executeTyped(Coord(0, 0));
    vm.stopPrank();
  }

  function testMultiAbilityCost() public {
    setUp();

    vm.startPrank(alice);
    SpawnSystem(system(SpawnSystemID)).executeTyped();
    vm.stopPrank();

    // Get base entity
    assertTrue(carriedByComponent.has(addressToEntity(alice)));
    uint256 baseEntity = carriedByComponent.getValue(addressToEntity(alice));

    Coord memory initialPosition = positionComponent.getValue(baseEntity);

    vm.roll(2);

    Coord memory targetPosition = Coord(
      initialPosition.x < gameConfig.worldWidth - 2 ? initialPosition.x + 1 : initialPosition.x - 1,
      initialPosition.y
    );

    // Give baseEntity two more movement organs for a total of three
    uint256 m1 = world.getUniqueEntityId();
    ComponentDevSystem(system(ComponentDevSystemID)).executeTyped(PortableComponentID, m1, abi.encode(1));
    ComponentDevSystem(system(ComponentDevSystemID)).executeTyped(AbilityMoveComponentID, m1, abi.encode(1));

    uint256 m2 = world.getUniqueEntityId();
    ComponentDevSystem(system(ComponentDevSystemID)).executeTyped(PortableComponentID, m2, abi.encode(1));
    ComponentDevSystem(system(ComponentDevSystemID)).executeTyped(AbilityMoveComponentID, m2, abi.encode(1));

    // Place in inventory
    ComponentDevSystem(system(ComponentDevSystemID)).executeTyped(CarriedByComponentID, m1, abi.encode(baseEntity));
    ComponentDevSystem(system(ComponentDevSystemID)).executeTyped(CarriedByComponentID, m2, abi.encode(baseEntity));

    vm.startPrank(alice);
    MoveSystem(system(MoveSystemID)).executeTyped(targetPosition);
    vm.stopPrank();

    // Energy should be:
    // gameConfig.initialEnergy - (gameConfig.moveCost - (2 * (3 - 1)))
    // 3 => number of movement organs
    assertEq(energyComponent.getValue(addressToEntity(alice)), gameConfig.initialEnergy - (gameConfig.moveCost - 4));
  }
}
