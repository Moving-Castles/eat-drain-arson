// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;
import "solecs/System.sol";
import { IWorld } from "solecs/interfaces/IWorld.sol";
import { getAddressById, addressToEntity } from "solecs/utils.sol";
import { QueryFragment, LibQuery, QueryType } from "solecs/LibQuery.sol";
import { Perlin } from "noise/Perlin.sol";
import { ABDKMath64x64 as Math } from "abdk-libraries-solidity/ABDKMath64x64.sol";
import { SPAWN_RESOURCE_PER_POSITION, MAX_INACTIVITY, GENERIC_ACTION_COOLDOWN } from "../config.sol";
import { EntityCategory } from "../types.sol";
import { PositionComponent, ID as PositionComponentID, Coord } from "../components/PositionComponent.sol";
import { ResourceComponent, ID as ResourceComponentID } from "../components/ResourceComponent.sol";
import { EnergyComponent, ID as EnergyComponentID } from "../components/EnergyComponent.sol";
import { CoolDownComponent, ID as CoolDownComponentID } from "../components/CoolDownComponent.sol";
import { EntityCategoryComponent, ID as EntityCategoryComponentID } from "../components/EntityCategoryComponent.sol";
import { StatsComponent, ID as StatsComponentID, Stats } from "../components/StatsComponent.sol";
import { CannibalComponent, ID as CannibalComponentID } from "../components/CannibalComponent.sol";
import { DeathComponent, ID as DeathComponentID } from "../components/DeathComponent.sol";

uint256 constant ID = uint256(keccak256("system.Gather"));

contract GatherSystem is System {
  constructor(IWorld _world, address _components) System(_world, _components) {}

  function checkForEntity(Coord memory position, uint32 typeOfEntity) private view returns (uint256[] memory) {
    PositionComponent positionComponent = PositionComponent(getAddressById(components, PositionComponentID));
    EntityCategoryComponent entityCategoryComponent = EntityCategoryComponent(
      getAddressById(components, EntityCategoryComponentID)
    );

    QueryFragment[] memory fragments = new QueryFragment[](2);
    fragments[0] = QueryFragment(QueryType.HasValue, positionComponent, abi.encode(position));
    fragments[1] = QueryFragment(QueryType.HasValue, entityCategoryComponent, abi.encode(typeOfEntity));
    return LibQuery.query(fragments);
  }

  function checkRequirements(uint256 player, uint32 energyInput) private {
    EnergyComponent energyComponent = EnergyComponent(getAddressById(components, EnergyComponentID));
    CoolDownComponent coolDownComponent = CoolDownComponent(getAddressById(components, CoolDownComponentID));
    EntityCategoryComponent entityCategoryComponent = EntityCategoryComponent(
      getAddressById(components, EntityCategoryComponentID)
    );
    DeathComponent deathComponent = DeathComponent(getAddressById(components, DeathComponentID));

    // Require entity to be player
    require(
      entityCategoryComponent.getValue(player) == uint32(EntityCategory.Player),
      "only (a living) player can gather."
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
    // Require the player to have enough energy
    require(energyComponent.getValue(player) >= energyInput, "not enough energy");
  }

  function getResourcesToExtract(Coord memory position, uint32 energyInput) private returns (uint32) {
    // Scale resource allocation by perlin noise value
    // resources = energyInput * (perlin noise / 2**16 <= precision)
    return
      uint32(
        uint64(
          Math.toInt(
            Math.mul(Math.fromUInt(energyInput), Math.div(Perlin.noise2d(position.x, position.y, 20, 16), 2 ** 16))
          )
        )
      );
  }

  function cannabalize(uint256 player, uint256 corpse) private {
    CannibalComponent cannibalComponent = CannibalComponent(getAddressById(components, CannibalComponentID));
    ResourceComponent resourceComponent = ResourceComponent(getAddressById(components, ResourceComponentID));
    EntityCategoryComponent entityCategoryComponent = EntityCategoryComponent(
      getAddressById(components, EntityCategoryComponentID)
    );

    // Transfer all resources from corpse to player
    resourceComponent.set(player, resourceComponent.getValue(player) + resourceComponent.getValue(corpse));
    resourceComponent.set(corpse, 0);
    // Turn corpse into ghost
    entityCategoryComponent.set(corpse, uint32(EntityCategory.Ghost));

    // Add corpse to player's cannibal list
    uint256[] memory currentCannibalArray = cannibalComponent.getValue(player);
    uint256[] memory newCannibalArray = new uint256[](currentCannibalArray.length + 1);
    for (uint32 i = 0; i < currentCannibalArray.length; i++) {
      newCannibalArray[i] = currentCannibalArray[i];
    }
    newCannibalArray[newCannibalArray.length - 1] = corpse;
    cannibalComponent.set(player, newCannibalArray);
  }

  function gather(uint256 player, Coord memory position, uint32 energyInput) private returns (uint32) {
    PositionComponent positionComponent = PositionComponent(getAddressById(components, PositionComponentID));
    EntityCategoryComponent entityCategoryComponent = EntityCategoryComponent(
      getAddressById(components, EntityCategoryComponentID)
    );
    ResourceComponent resourceComponent = ResourceComponent(getAddressById(components, ResourceComponentID));

    // Check for terrain component in current location
    uint256[] memory terrainAtPosition = checkForEntity(position, uint32(EntityCategory.Terrain));

    uint32 resourceToExtract = getResourcesToExtract(position, energyInput);

    if (terrainAtPosition.length == 0) {
      // The position HAS NOT been gathered before,
      // there are INITIAL_RESOURCE_PER_POSITION resources available

      // Cap resource extraction at INITIAL_RESOURCE_PER_POSITION
      if (resourceToExtract > SPAWN_RESOURCE_PER_POSITION) resourceToExtract = SPAWN_RESOURCE_PER_POSITION;

      // Create new terrain block at position
      uint256 newTerrainEntity = world.getUniqueEntityId();
      positionComponent.set(newTerrainEntity, position);
      entityCategoryComponent.set(newTerrainEntity, uint32(EntityCategory.Terrain));
      resourceComponent.set(newTerrainEntity, SPAWN_RESOURCE_PER_POSITION - resourceToExtract);
    } else {
      // The position HAS been gathered before,
      // there are terrainResourceBalance resources available

      uint32 terrainResourceBalance = resourceComponent.getValue(terrainAtPosition[0]);

      // Require there to be resources in the position
      require(terrainResourceBalance > 0, "no resources in position");

      // Cap resource extraction at available resources
      if (resourceToExtract > terrainResourceBalance) resourceToExtract = terrainResourceBalance;

      // Update value on terrain entity
      resourceComponent.set(terrainAtPosition[0], terrainResourceBalance - resourceToExtract);
    }

    // Update resource related values on player entity
    resourceComponent.set(player, resourceComponent.getValue(player) + resourceToExtract);

    return resourceToExtract;
  }

  function updatePlayer(uint256 player, uint32 energyInput) private {
    EnergyComponent energyComponent = EnergyComponent(getAddressById(components, EnergyComponentID));
    CoolDownComponent coolDownComponent = CoolDownComponent(getAddressById(components, CoolDownComponentID));

    energyComponent.set(player, energyComponent.getValue(player) - energyInput);
    coolDownComponent.set(player, block.number + GENERIC_ACTION_COOLDOWN);
  }

  function updateStats(uint256 entity, uint32 resourceToExtract) private {
    StatsComponent statsComponent = StatsComponent(getAddressById(components, StatsComponentID));
    Stats memory currentStats = statsComponent.getValue(entity);
    currentStats.gathered += resourceToExtract;
    statsComponent.set(entity, currentStats);
  }

  function checkIfDead(uint256 player) private {
    EnergyComponent energyComponent = EnergyComponent(getAddressById(components, EnergyComponentID));
    EntityCategoryComponent entityCategoryComponent = EntityCategoryComponent(
      getAddressById(components, EntityCategoryComponentID)
    );
    CoolDownComponent coolDownComponent = CoolDownComponent(getAddressById(components, CoolDownComponentID));

    if (energyComponent.getValue(player) <= 0) {
      entityCategoryComponent.set(player, uint32(EntityCategory.Corpse));
      coolDownComponent.set(player, 0);
    }
  }

  function updateDeathBlock(uint256 player) private {
    DeathComponent deathComponent = DeathComponent(getAddressById(components, DeathComponentID));
    deathComponent.set(player, block.number + MAX_INACTIVITY);
  }

  function execute(bytes memory arguments) public returns (bytes memory) {
    (uint256 entity, uint32 energyInput) = abi.decode(arguments, (uint256, uint32));

    checkRequirements(entity, energyInput);

    // Get player position
    PositionComponent positionComponent = PositionComponent(getAddressById(components, PositionComponentID));
    Coord memory playerPosition = positionComponent.getValue(entity);

    // Require there to not be a fire in position
    require(checkForEntity(playerPosition, uint32(EntityCategory.Fire)).length == 0, "can not gather in fire");

    // Check for corpses in current location
    uint256[] memory corpsesAtPosition = checkForEntity(playerPosition, uint32(EntityCategory.Corpse));

    if (corpsesAtPosition.length > 0) {
      cannabalize(entity, corpsesAtPosition[0]);
    } else {
      uint32 extractedResources = gather(entity, playerPosition, energyInput);
      updateStats(entity, extractedResources);
    }

    updatePlayer(entity, energyInput);
    updateDeathBlock(entity);
    checkIfDead(entity);
  }

  function executeTyped(uint256 entity, uint32 energyInput) public returns (bytes memory) {
    return execute(abi.encode(entity, energyInput));
  }
}
