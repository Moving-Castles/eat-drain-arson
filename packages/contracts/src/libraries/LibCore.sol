// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.17;

import { QueryFragment, QueryType } from "solecs/interfaces/Query.sol";
import { LibQuery } from "solecs/LibQuery.sol";
import { IWorld } from "solecs/interfaces/IWorld.sol";

import { IUint256Component } from "solecs/interfaces/IUint256Component.sol";
import { getAddressById, addressToEntity } from "solecs/utils.sol";

import { INITIAL_ENERGY } from "../utils/config.sol";

import { ControlComponent, ID as ControlComponentID } from "../components/ControlComponent.sol";
import { CreationBlockComponent, ID as CreationBlockComponentID } from "../components/CreationBlockComponent.sol";
import { ReadyBlockComponent, ID as ReadyBlockComponentID } from "../components/ReadyBlockComponent.sol";
import { EnergyComponent, ID as EnergyComponentID } from "../components/EnergyComponent.sol";
import { PortableComponent, ID as PortableComponentID } from "../components/PortableComponent.sol";
import { PositionComponent, ID as PositionComponentID, Coord } from "../components/PositionComponent.sol";
import { InventoryComponent, ID as InventoryComponentID } from "../components/InventoryComponent.sol";

library LibCore {
  /**
   * Spawn a Core
   *
   * @param _components World components
   * @param _coreEntity Entity Id. Should be address of the owner/controller of the Core
   */
  function spawn(IUint256Component _components, uint256 _coreEntity) internal {
    // !! TODO: access control
    ReadyBlockComponent readyBlockComponent = ReadyBlockComponent(getAddressById(_components, ReadyBlockComponentID));
    EnergyComponent energyComponent = EnergyComponent(getAddressById(_components, EnergyComponentID));
    PortableComponent portableComponent = PortableComponent(getAddressById(_components, PortableComponentID));
    CreationBlockComponent creationBlockComponent = CreationBlockComponent(
      getAddressById(_components, CreationBlockComponentID)
    );

    creationBlockComponent.set(_coreEntity, block.number);
    readyBlockComponent.set(_coreEntity, block.number);
    energyComponent.set(_coreEntity, INITIAL_ENERGY);
    portableComponent.set(_coreEntity);
  }

  /**
   * Get the base entity controlled by a core
   *
   * @param _components World components
   * @param _coreEntity Core entity
   * @return unsigned ID of the base entity
   */
  function getControlledEntity(IUint256Component _components, uint256 _coreEntity) internal view returns (uint256) {
    ControlComponent controlComponent = ControlComponent(getAddressById(_components, ControlComponentID));
    require(controlComponent.has(_coreEntity), "entity is not a core");
    return controlComponent.getValue(_coreEntity);
  }

  /**
   * Set the base entity controlled by a core
   *
   * @param _components World components
   * @param _coreEntity Core entity
   * @param _baseEntity Base entity
   */
  function setControlledEntity(IUint256Component _components, uint256 _coreEntity, uint256 _baseEntity) internal {
    ControlComponent controlComponent = ControlComponent(getAddressById(_components, ControlComponentID));
    controlComponent.set(_coreEntity, _baseEntity);
  }

  /**
   * Subtract energy
   *
   * @param _components World components
   * @param _coreEntity Core entity
   * @param _energyCost Energy to subtract
   * @return bool False if the core does not have enough energy
   */
  function subtractEnergy(
    IUint256Component _components,
    uint256 _coreEntity,
    uint32 _energyCost
  ) internal returns (bool) {
    EnergyComponent energyComponent = EnergyComponent(getAddressById(_components, EnergyComponentID));
    uint32 currentEnergy = energyComponent.getValue(_coreEntity);
    if (currentEnergy < _energyCost) return false;
    energyComponent.set(_coreEntity, currentEnergy - _energyCost);
    return true;
  }
}
