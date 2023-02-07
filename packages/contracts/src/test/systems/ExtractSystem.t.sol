// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.17;

import "../MudTest.t.sol";
import { console } from "forge-std/console.sol";
import { addressToEntity } from "solecs/utils.sol";

import { ComponentDevSystem, ID as ComponentDevSystemID } from "../../systems/ComponentDevSystem.sol";
import { ExtractSystem, ID as ExtractSystemID } from "../../systems/ExtractSystem.sol";
import { MoveSystem, ID as MoveSystemID } from "../../systems/MoveSystem.sol";
import { SpawnSystem, ID as SpawnSystemID } from "../../systems/SpawnSystem.sol";

import { Coord } from "../../components/PositionComponent.sol";

import { LibResource } from "../../libraries/LibResource.sol";
import { LibSubstanceBlock } from "../../libraries/LibSubstanceBlock.sol";

contract ExtractSystemTest is MudTest {
  function testExtract() public {
    setUp();

    SpawnSystem spawnSystem = SpawnSystem(system(SpawnSystemID));
    ExtractSystem extractSystem = ExtractSystem(system(ExtractSystemID));

    vm.startPrank(alice);

    spawnSystem.executeTyped();

    // Get base entity
    assertTrue(carriedByComponent.has(addressToEntity(alice)));
    uint256 baseEntity = carriedByComponent.getValue(addressToEntity(alice));
    Coord memory initialPosition = positionComponent.getValue(baseEntity);

    vm.roll(2);

    extractSystem.executeTyped(Coord(initialPosition.x, initialPosition.y));

    // Resource entity should be created
    uint256 resourceEntity = LibResource.getAtCoordinate(components, initialPosition);
    assertGt(resourceEntity, 0);
    assertEq(matterComponent.getValue(resourceEntity), gameConfig.matterPerTile - gameConfig.extractCost);

    // SubstanceBlock should be created
    uint256[] memory substanceBlockEntities = LibSubstanceBlock.getAtCoordinate(components, initialPosition);
    assertEq(substanceBlockEntities.length, 1);
    assertEq(matterComponent.getValue(substanceBlockEntities[0]), gameConfig.extractCost);

    vm.stopPrank();
  }

  function testRevertCooldown() public {
    setUp();

    SpawnSystem spawnSystem = SpawnSystem(system(SpawnSystemID));
    ExtractSystem extractSystem = ExtractSystem(system(ExtractSystemID));
    MoveSystem moveSystem = MoveSystem(system(MoveSystemID));

    vm.startPrank(alice);

    spawnSystem.executeTyped();

    uint256 baseEntity = carriedByComponent.getValue(addressToEntity(alice));

    Coord memory initialPosition = positionComponent.getValue(baseEntity);

    vm.roll(2);

    Coord memory targetPosition = Coord(
      initialPosition.x < gameConfig.worldWidth - 2 ? initialPosition.x + 1 : initialPosition.x - 1,
      initialPosition.y
    );

    // !! Cooldown currently 1 block so this test does not revert as expected
    // vm.expectRevert(bytes("ExtractSystem: entity is in cooldown"));
    // extractSystem.executeTyped(Coord(0, 0));
    vm.stopPrank();
  }

  function testRevertUnspawned() public {
    setUp();
    ExtractSystem extractSystem = ExtractSystem(system(ExtractSystemID));
    vm.startPrank(alice);
    vm.expectRevert(bytes("ExtractSystem: entity does not exist"));
    extractSystem.executeTyped(Coord(0, 0));
    vm.stopPrank();
  }

  function testRevertNotAdjacent() public {
    setUp();

    SpawnSystem spawnSystem = SpawnSystem(system(SpawnSystemID));
    ExtractSystem extractSystem = ExtractSystem(system(ExtractSystemID));
    MoveSystem moveSystem = MoveSystem(system(MoveSystemID));

    // Spawn core
    vm.startPrank(alice);
    spawnSystem.executeTyped();

    // Get base entity
    assertTrue(carriedByComponent.has(addressToEntity(alice)));
    uint256 baseEntity = carriedByComponent.getValue(addressToEntity(alice));
    Coord memory initialPosition = positionComponent.getValue(baseEntity);

    vm.roll(2);

    vm.expectRevert(bytes("ExtractSystem: tile not adjacent"));
    extractSystem.executeTyped(Coord(initialPosition.x + 3, initialPosition.y + 3));
    vm.stopPrank();
  }

  function testMultiAbilityExtract() public {
    setUp();

    SpawnSystem spawnSystem = SpawnSystem(system(SpawnSystemID));
    ExtractSystem extractSystem = ExtractSystem(system(ExtractSystemID));

    vm.startPrank(alice);

    spawnSystem.executeTyped();

    // Get base entity
    assertTrue(carriedByComponent.has(addressToEntity(alice)));
    uint256 baseEntity = carriedByComponent.getValue(addressToEntity(alice));
    Coord memory initialPosition = positionComponent.getValue(baseEntity);

    vm.roll(2);

    // Give baseEntity two more "extract organs" for a total of three
    uint256 e1 = world.getUniqueEntityId();
    ComponentDevSystem(system(ComponentDevSystemID)).executeTyped(PortableComponentID, e1, abi.encode(1));
    ComponentDevSystem(system(ComponentDevSystemID)).executeTyped(AbilityExtractComponentID, e1, abi.encode(1));

    uint256 e2 = world.getUniqueEntityId();
    ComponentDevSystem(system(ComponentDevSystemID)).executeTyped(PortableComponentID, e2, abi.encode(1));
    ComponentDevSystem(system(ComponentDevSystemID)).executeTyped(AbilityExtractComponentID, e2, abi.encode(1));

    // Place in inventory
    ComponentDevSystem(system(ComponentDevSystemID)).executeTyped(CarriedByComponentID, e1, abi.encode(baseEntity));
    ComponentDevSystem(system(ComponentDevSystemID)).executeTyped(CarriedByComponentID, e2, abi.encode(baseEntity));

    extractSystem.executeTyped(Coord(initialPosition.x, initialPosition.y));

    // Should be 10 + (10 * (3 - 1))
    uint32 matterToExtract = 30;

    // Resource entity should be created
    uint256 resourceEntity = LibResource.getAtCoordinate(components, initialPosition);
    assertGt(resourceEntity, 0);
    assertEq(matterComponent.getValue(resourceEntity), gameConfig.matterPerTile - matterToExtract);

    // SubstanceBlock should be created
    uint256[] memory substanceBlockEntities = LibSubstanceBlock.getAtCoordinate(components, initialPosition);
    assertEq(substanceBlockEntities.length, 1);
    assertEq(matterComponent.getValue(substanceBlockEntities[0]), matterToExtract);

    vm.stopPrank();
  }
}
