// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.0;

import "../MudTest.t.sol";
import { entityType } from "../../constants.sol";
import { QueryFragment, LibQuery, QueryType } from "solecs/LibQuery.sol";
import { Perlin } from "noise/Perlin.sol";
import { ABDKMath64x64 as Math } from "abdk-libraries-solidity/ABDKMath64x64.sol";

import { SpawnSystem, ID as SpawnSystemID } from "../../systems/SpawnSystem.sol";
import { GatherSystem, ID as GatherSystemID } from "../../systems/GatherSystem.sol";
import { PositionComponent, ID as PositionComponentID, Coord } from "../../components/PositionComponent.sol";
import { ResourceComponent, ID as ResourceComponentID } from "../../components/ResourceComponent.sol";
import { EnergyComponent, ID as EnergyComponentID } from "../../components/EnergyComponent.sol";
import { EntityTypeComponent, ID as EntityTypeComponentID } from "../../components/EntityTypeComponent.sol";
import { StatsComponent, ID as StatsComponentID, Stats } from "../../components/StatsComponent.sol";

contract GatherSystemTest is MudTest {
  function testExecute() public {
    uint256 entity = 1;

    // Initialize components
    EnergyComponent energyComponent = EnergyComponent(getAddressById(components, EnergyComponentID));
    ResourceComponent resourceComponent = ResourceComponent(getAddressById(components, ResourceComponentID));
    PositionComponent positionComponent = PositionComponent(getAddressById(components, PositionComponentID));
    EntityTypeComponent entityTypeComponent = EntityTypeComponent(getAddressById(components, EntityTypeComponentID));
    StatsComponent statsComponent = StatsComponent(getAddressById(components, StatsComponentID));

    // Spawn player
    SpawnSystem(system(SpawnSystemID)).executeTyped(entity);

    Coord memory playerPosition = positionComponent.getValue(entity);

    // Convert 50 energy => resource
    GatherSystem(system(GatherSystemID)).executeTyped(entity, 50);

    // resourceToExtract = 50 * (perlin noise / 2**16 <= precision)
    int32 resourceToExtract = int32(
      Math.toInt(
        Math.mul(Math.fromInt(50), Math.div(Perlin.noise2d(playerPosition.x, playerPosition.y, 20, 16), 2 ** 16))
      )
    );

    // Players resource balance should be 200 + value calculated based on perlin factor
    assertEq(resourceComponent.getValue(entity), 200 + resourceToExtract);
    // Energy should be 1000 - 50
    assertEq(energyComponent.getValue(entity), 950);

    assertEq(statsComponent.getValue(entity).gathered, resourceToExtract);

    // Check for terrain component in current location
    Coord memory currentPosition = positionComponent.getValue(entity);
    QueryFragment[] memory fragments = new QueryFragment[](2);
    fragments[0] = QueryFragment(QueryType.HasValue, positionComponent, abi.encode(currentPosition));
    fragments[1] = QueryFragment(QueryType.HasValue, entityTypeComponent, abi.encode(uint32(entityType.Terrain)));
    uint256[] memory entitiesAtPosition = LibQuery.query(fragments);
    assertEq(entitiesAtPosition.length, 1);
    // Terrain component should have 100 - resourceToExtract
    assertEq(resourceComponent.getValue(entitiesAtPosition[0]), 100 - resourceToExtract);
  }
}
