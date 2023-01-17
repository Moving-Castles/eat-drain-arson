// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;
import "solecs/System.sol";
import { IWorld } from "solecs/interfaces/IWorld.sol";
import { getAddressById, addressToEntity } from "solecs/utils.sol";

import { WORLD_HEIGHT, WORLD_WIDTH, INITIAL_ENERGY, INITIAL_RESOURCE, MAX_INACTIVITY } from "../utils/config.sol";

import { LibInventory } from "../libraries/LibInventory.sol";
import { LibMove } from "../libraries/LibMove.sol";

import { ControlComponent, ID as ControlComponentID } from "../components/ControlComponent.sol";
import { CreationBlockComponent, ID as CreationBlockComponentID } from "../components/CreationBlockComponent.sol";
import { ReadyBlockComponent, ID as ReadyBlockComponentID } from "../components/ReadyBlockComponent.sol";
import { EnergyComponent, ID as EnergyComponentID } from "../components/EnergyComponent.sol";
import { PortableComponent, ID as PortableComponentID } from "../components/PortableComponent.sol";
import { PositionComponent, ID as PositionComponentID, Coord } from "../components/PositionComponent.sol";
import { InventoryComponent, ID as InventoryComponentID } from "../components/InventoryComponent.sol";

uint256 constant ID = uint256(keccak256("system.Spawn"));

contract SpawnSystem is System {
  constructor(IWorld _world, address _components) System(_world, _components) {}

  function execute(bytes memory arguments) public returns (bytes memory) {
    uint256 coreEntity = abi.decode(arguments, (uint256));
    uint256 baseEntity = world.getUniqueEntityId();

    ControlComponent controlComponent = ControlComponent(getAddressById(components, ControlComponentID));
    ReadyBlockComponent readyBlockComponent = ReadyBlockComponent(getAddressById(components, ReadyBlockComponentID));
    EnergyComponent energyComponent = EnergyComponent(getAddressById(components, EnergyComponentID));
    PortableComponent portableComponent = PortableComponent(getAddressById(components, PortableComponentID));
    CreationBlockComponent creationBlockComponent = CreationBlockComponent(
      getAddressById(components, CreationBlockComponentID)
    );

    creationBlockComponent.set(coreEntity, block.number);
    readyBlockComponent.set(coreEntity, block.number);
    energyComponent.set(coreEntity, INITIAL_ENERGY);
    portableComponent.set(coreEntity);
    controlComponent.set(coreEntity, baseEntity);

    // ---
    LibInventory.addToInventory(components, baseEntity, coreEntity);
    LibMove.setRandomPosition(components, baseEntity);
  }

  function executeTyped(uint256 _entity) public returns (bytes memory) {
    return execute(abi.encode(_entity));
  }
}
