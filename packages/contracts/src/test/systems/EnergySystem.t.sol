// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.0;

import "../MudTest.t.sol";
import { console } from "forge-std/console.sol";
import { Cheats } from "../utils/Cheats.sol";
import { INITIAL_ENERGY, INITIAL_RESOURCE, RESOURCE_TO_ENERGY_CONVERSION_RATE } from "../../config.sol";
import { SpawnSystem, ID as SpawnSystemID } from "../../systems/SpawnSystem.sol";
import { GatherSystem, ID as GatherSystemID } from "../../systems/GatherSystem.sol";
import { EnergySystem, ID as EnergySystemID } from "../../systems/EnergySystem.sol";
import { ComponentDevSystem, ID as ComponentDevSystemID } from "../../systems/ComponentDevSystem.sol";

contract EnergySystemTest is MudTest {
  function testExecute(uint32 initialResources) public {
    // avoid overflow
    vm.assume(initialResources <= type(uint32).max / RESOURCE_TO_ENERGY_CONVERSION_RATE - INITIAL_ENERGY);

    uint256 entity = 1;

    // Spawn player
    SpawnSystem(system(SpawnSystemID)).executeTyped(entity);

    console.log(resourceComponent.getValue(entity));

    // Give player initial resources
    ComponentDevSystem(system(ComponentDevSystemID)).executeTyped(
      ResourceComponentID,
      entity,
      abi.encode(initialResources)
    );

    console.log(resourceComponent.getValue(entity));

    // Convert resources => energy
    EnergySystem(system(EnergySystemID)).executeTyped(entity, initialResources);
    // 0
    assertEq(resourceComponent.getValue(entity), 0);
    // INITIAL_ENERGY + initialResources * RESOURCE_TO_ENERGY_CONVERSION_RATE
    assertEq(energyComponent.getValue(entity), INITIAL_ENERGY + initialResources * RESOURCE_TO_ENERGY_CONVERSION_RATE);
    // Check stats are updated
    assertEq(statsComponent.getValue(entity).eaten, initialResources);
  }
}
