// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.17;

import "../MudTest.t.sol";
import { console } from "forge-std/console.sol";
import { addressToEntity } from "solecs/utils.sol";

import { MoveSystem, ID as MoveSystemID } from "../../systems/MoveSystem.sol";
import { SpawnSystem, ID as SpawnSystemID } from "../../systems/SpawnSystem.sol";

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
}
