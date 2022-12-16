// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.0;

import "../MudTest.t.sol";
import { EntityType } from "../../types.sol";
import { MAX_INACTIVITY } from "../../config.sol";
import { SpawnSystem, ID as SpawnSystemID } from "../../systems/SpawnSystem.sol";
import { DeathComponent, ID as DeathComponentID } from "../../components/DeathComponent.sol";
import { MoveSystem, ID as MoveSystemID } from "../../systems/MoveSystem.sol";

contract DeathMechanicsTest is MudTest {
  function testExecute() public {
    uint256 alice = 1;

    // Initialize components
    DeathComponent deathComponent = DeathComponent(getAddressById(components, DeathComponentID));

    // Spawn Alice
    console.log("block:");
    console.log(block.number);
    SpawnSystem(system(SpawnSystemID)).executeTyped(alice);
    console.log("deathBlock:");
    console.log(deathComponent.getValue(alice));
    assertEq(deathComponent.getValue(alice), block.number + MAX_INACTIVITY);

    vm.roll(MAX_INACTIVITY);

    console.log("block:");
    console.log(block.number);
    MoveSystem(system(MoveSystemID)).executeTyped(alice, 10, 3);
    console.log("deathBlock:");
    console.log(deathComponent.getValue(alice));
    assertEq(deathComponent.getValue(alice), block.number + MAX_INACTIVITY);

    vm.roll(block.number + MAX_INACTIVITY);

    console.log("block:");
    console.log(block.number);
    vm.expectRevert("death block past. you are dead");
    MoveSystem(system(MoveSystemID)).executeTyped(alice, 10, 3);
  }
}
