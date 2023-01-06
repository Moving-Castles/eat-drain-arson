// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.0;

import "../MudTest.t.sol";
import { EntityCategory } from "../../types.sol";
import { INITIAL_ENERGY, FIRE_BURNTIME_MULTIPLIER, COST_TO_MAKE_FIRE, MINIMUM_FIRE_SIZE, GENERIC_ACTION_COOLDOWN } from "../../config.sol";
import { QueryFragment, LibQuery, QueryType } from "solecs/LibQuery.sol";
import { SpawnSystem, ID as SpawnSystemID } from "../../systems/SpawnSystem.sol";
import { FireSystem, ID as FireSystemID } from "../../systems/FireSystem.sol";
import { ComponentDevSystem, ID as ComponentDevSystemID } from "../../systems/ComponentDevSystem.sol";
import { Coord } from "../../components/PositionComponent.sol";

contract FireSystemTest is MudTest {
  function testExecute(uint32 initialResources) public {
    vm.assume(initialResources >= MINIMUM_FIRE_SIZE * 2);
    // burn half of the resources twice
    uint32 resHalf1 = initialResources / 2;
    uint32 resHalf2 = initialResources - resHalf1;

    uint256 entity = 42;

    // Spawn player
    SpawnSystem(system(SpawnSystemID)).executeTyped(entity);

    // Give player initial resources
    ComponentDevSystem(system(ComponentDevSystemID)).executeTyped(
      ResourceComponentID,
      entity,
      abi.encode(initialResources)
    );

    // Create fire
    FireSystem(system(FireSystemID)).executeTyped(entity, resHalf1);
    // init resources - half
    assertEq(resourceComponent.getValue(entity), initialResources - resHalf1);
    // init energy - cost
    assertEq(energyComponent.getValue(entity), INITIAL_ENERGY - COST_TO_MAKE_FIRE);

    // Check for fire component in current location
    Coord memory currentPosition = positionComponent.getValue(entity);
    QueryFragment[] memory fragments = new QueryFragment[](2);
    fragments[0] = QueryFragment(QueryType.HasValue, positionComponent, abi.encode(currentPosition));
    fragments[1] = QueryFragment(QueryType.HasValue, entityCategoryComponent, abi.encode(EntityCategory.Fire));
    uint256[] memory entitiesAtPosition = LibQuery.query(fragments);
    assertEq(entitiesAtPosition.length, 1);
    // Cooldown on fire component should be blocknumber + (resources added * multiplier):
    assertEq(
      coolDownComponent.getValue(entitiesAtPosition[0]),
      block.number + uint256(resHalf1) * FIRE_BURNTIME_MULTIPLIER
    );
    // 1st half of the resources has been burnt
    assertEq(resourceComponent.getValue(entitiesAtPosition[0]), resHalf1);
    // Creator should be set
    assertEq(uint256(creatorComponent.getValue(entitiesAtPosition[0])[0]), entity);
    // Check stats are updated
    assertEq(statsComponent.getValue(entity).burnt, resHalf1);

    // Fast forward past player cool down block
    vm.roll(block.number + GENERIC_ACTION_COOLDOWN + 1);

    // Add to the existing fire
    FireSystem(system(FireSystemID)).executeTyped(entity, resHalf2);
    // init resources - 1st half - 2nd half
    assertEq(resourceComponent.getValue(entity), 0);
    // init energy - previous cost - this cost
    assertEq(energyComponent.getValue(entity), INITIAL_ENERGY - 2 * COST_TO_MAKE_FIRE);
    // Cooldown on fire component should be cooldownblock + (resources added * FIRE_BURNTIME_MULTIPLIER):
    assertEq(
      coolDownComponent.getValue(entitiesAtPosition[0]),
      1 + uint256(initialResources) * FIRE_BURNTIME_MULTIPLIER
    );
    // all init resources have been burnt
    assertEq(resourceComponent.getValue(entitiesAtPosition[0]), initialResources);
    // Creator should not have changed
    assertEq(uint256(creatorComponent.getValue(entitiesAtPosition[0])[0]), entity);
    // Check stats are updated
    assertEq(statsComponent.getValue(entity).burnt, initialResources);
  }
}
