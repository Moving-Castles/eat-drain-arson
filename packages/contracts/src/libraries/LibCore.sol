// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.17;

import { QueryFragment, QueryType } from "solecs/interfaces/Query.sol";
import { LibQuery } from "solecs/LibQuery.sol";
import { IWorld } from "solecs/interfaces/IWorld.sol";

import { IUint256Component } from "solecs/interfaces/IUint256Component.sol";
import { getAddressById, addressToEntity } from "solecs/utils.sol";

import { INITIAL_ENERGY } from "../utils/config.sol";

import { CoreComponent, ID as CoreComponentID } from "../components/CoreComponent.sol";
import { CreationBlockComponent, ID as CreationBlockComponentID } from "../components/CreationBlockComponent.sol";
import { ReadyBlockComponent, ID as ReadyBlockComponentID } from "../components/ReadyBlockComponent.sol";
import { EnergyComponent, ID as EnergyComponentID } from "../components/EnergyComponent.sol";
import { PortableComponent, ID as PortableComponentID } from "../components/PortableComponent.sol";
import { CarriedByComponent, ID as CarriedByComponentID } from "../components/CarriedByComponent.sol";

library LibCore {
  /**
   * Spawn a Core
   *
   * @param _components World components
   * @param _coreEntity Entity Id. Should be address of the owner/controller of the Core
   */
  function spawn(IUint256Component _components, uint256 _coreEntity) internal {
    CoreComponent coreComponent = CoreComponent(getAddressById(_components, CoreComponentID));
    ReadyBlockComponent readyBlockComponent = ReadyBlockComponent(getAddressById(_components, ReadyBlockComponentID));
    EnergyComponent energyComponent = EnergyComponent(getAddressById(_components, EnergyComponentID));
    PortableComponent portableComponent = PortableComponent(getAddressById(_components, PortableComponentID));
    CreationBlockComponent creationBlockComponent = CreationBlockComponent(
      getAddressById(_components, CreationBlockComponentID)
    );

    coreComponent.set(_coreEntity);
    creationBlockComponent.set(_coreEntity, block.number);
    readyBlockComponent.set(_coreEntity, block.number);
    energyComponent.set(_coreEntity, INITIAL_ENERGY);
    portableComponent.set(_coreEntity);
  }

  /**
   * Checks if a core with this id exists
   *
   * @param _components world components
   * @param _coreEntity core entity Id
   * @return bool does core with this Id exist?
   */
  function isSpawned(IUint256Component _components, uint256 _coreEntity) internal view returns (bool) {
    CoreComponent coreComponent = CoreComponent(getAddressById(_components, CoreComponentID));
    return coreComponent.has(_coreEntity);
  }

  /**
   * Check energy
   *
   * @param _components World components
   * @param _coreEntity Core entity
   * @param _amount Amount to check against
   * @return bool False if the core does not have enough energy
   */
  function checkEnergy(
    IUint256Component _components,
    uint256 _coreEntity,
    uint32 _amount
  ) internal view returns (bool) {
    EnergyComponent energyComponent = EnergyComponent(getAddressById(_components, EnergyComponentID));
    uint32 currentEnergy = energyComponent.getValue(_coreEntity);
    if (currentEnergy < _amount) return false;
    return true;
  }

  /**
   * Decrease energy
   *
   * @param _components World components
   * @param _coreEntity Core entity
   * @param _amount Amount to decrease by
   * @return bool False if the core does not have enough energy
   */
  function decreaseEnergy(IUint256Component _components, uint256 _coreEntity, uint32 _amount) internal returns (bool) {
    EnergyComponent energyComponent = EnergyComponent(getAddressById(_components, EnergyComponentID));
    uint32 currentEnergy = energyComponent.getValue(_coreEntity);
    if (currentEnergy < _amount) return false;
    energyComponent.set(_coreEntity, currentEnergy - _amount);
    return true;
  }

  /**
   * Increase energy
   *
   * @param _components World components
   * @param _coreEntity Core entity
   * @param _amount Amount to increase by
   */
  function increaseEnergy(IUint256Component _components, uint256 _coreEntity, uint32 _amount) internal {
    EnergyComponent energyComponent = EnergyComponent(getAddressById(_components, EnergyComponentID));
    uint32 currentEnergy = energyComponent.getValue(_coreEntity);
    energyComponent.set(_coreEntity, currentEnergy + _amount);
  }
}
