// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;
import "solecs/System.sol";
import { IWorld } from "solecs/interfaces/IWorld.sol";
import { getAddressById, addressToEntity } from "solecs/utils.sol";
import { EntityCategory } from "../types.sol";
import { RESOURCE_TO_ENERGY_CONVERSION_RATE, MAX_INACTIVITY, GENERIC_ACTION_COOLDOWN } from "../config.sol";

import { EnergyComponent, ID as EnergyComponentID } from "../components/EnergyComponent.sol";
import { ResourceComponent, ID as ResourceComponentID } from "../components/ResourceComponent.sol";
import { CoolDownComponent, ID as CoolDownComponentID } from "../components/CoolDownComponent.sol";
import { StatsComponent, ID as StatsComponentID, Stats } from "../components/StatsComponent.sol";
import { EntityCategoryComponent, ID as EntityCategoryComponentID } from "../components/EntityCategoryComponent.sol";
import { DeathComponent, ID as DeathComponentID } from "../components/DeathComponent.sol";

uint256 constant ID = uint256(keccak256("system.Energy"));

contract EnergySystem is System {
  constructor(IWorld _world, address _components) System(_world, _components) {}

  function checkRequirements(uint256 player, uint32 resourceInput) private {
    EntityCategoryComponent entityCategoryComponent = EntityCategoryComponent(
      getAddressById(components, EntityCategoryComponentID)
    );
    CoolDownComponent coolDownComponent = CoolDownComponent(getAddressById(components, CoolDownComponentID));
    ResourceComponent resourceComponent = ResourceComponent(getAddressById(components, ResourceComponentID));
    DeathComponent deathComponent = DeathComponent(getAddressById(components, DeathComponentID));
    EnergyComponent energyComponent = EnergyComponent(getAddressById(components, EnergyComponentID));

    // Require entity to be a player
    require(
      entityCategoryComponent.getValue(player) == uint32(EntityCategory.Player),
      "only (a living) player can eat."
    );

    // Require cooldown period to be over
    require(coolDownComponent.getValue(player) < block.number, "in cooldown period");

    // Require the player to not be past its death block
    if (deathComponent.getValue(player) <= block.number) {
      entityCategoryComponent.set(player, uint32(EntityCategory.Corpse));
      coolDownComponent.set(player, 0);
      energyComponent.set(player, 0);
      require(false, "death block past. you are dead");
    }

    // Require the player to have enough resource
    require(resourceComponent.getValue(player) >= resourceInput, "not enough resources");
  }

  function updatePlayer(uint256 player, uint32 resourceInput) private {
    EnergyComponent energyComponent = EnergyComponent(getAddressById(components, EnergyComponentID));
    ResourceComponent resourceComponent = ResourceComponent(getAddressById(components, ResourceComponentID));
    CoolDownComponent coolDownComponent = CoolDownComponent(getAddressById(components, CoolDownComponentID));

    // 1 resource => RESOURCE_TO_ENERGY_CONVERSION_RATE energy
    resourceComponent.set(player, resourceComponent.getValue(player) - resourceInput);
    energyComponent.set(player, energyComponent.getValue(player) + resourceInput * RESOURCE_TO_ENERGY_CONVERSION_RATE);

    // Add cooldown points
    coolDownComponent.set(player, block.number + GENERIC_ACTION_COOLDOWN);
  }

  function updateStats(uint256 player, uint32 resourceInput) private {
    StatsComponent statsComponent = StatsComponent(getAddressById(components, StatsComponentID));
    Stats memory currentStats = statsComponent.getValue(player);
    currentStats.eaten += resourceInput;
    statsComponent.set(player, currentStats);
  }

  function updateDeathBlock(uint256 player) private {
    DeathComponent deathComponent = DeathComponent(getAddressById(components, DeathComponentID));
    deathComponent.set(player, block.number + MAX_INACTIVITY);
  }

  function execute(bytes memory arguments) public returns (bytes memory) {
    (uint256 entity, uint32 resourceInput) = abi.decode(arguments, (uint256, uint32));
    checkRequirements(entity, resourceInput);
    updatePlayer(entity, resourceInput);
    updateStats(entity, resourceInput);
    updateDeathBlock(entity);
  }

  function executeTyped(uint256 entity, uint32 resourceInput) public returns (bytes memory) {
    return execute(abi.encode(entity, resourceInput));
  }
}
