// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.0;

import "../MudTest.t.sol";
import { EntityCategory } from "../../types.sol";
import { INITIAL_ENERGY } from "../../config.sol";
import { QueryFragment, LibQuery, QueryType } from "solecs/LibQuery.sol";
import { SpawnSystem, ID as SpawnSystemID } from "../../systems/SpawnSystem.sol";
import { PlaySystem, ID as PlaySystemID } from "../../systems/PlaySystem.sol";

contract PlaySystemTest is MudTest {
  function testExecute() public {
    uint256 entity = 42;

    // Spawn player
    SpawnSystem(system(SpawnSystemID)).executeTyped(entity);

    // Play
    PlaySystem(system(PlaySystemID)).executeTyped(entity, 50);
    // 100 - 50
    assertEq(energyComponent.getValue(entity), INITIAL_ENERGY - 50);
    // 1 + 10
    assertEq(coolDownComponent.getValue(entity), 21);
    // 1 + 20
    assertEq(playingComponent.getValue(entity), 21);
  }
}
