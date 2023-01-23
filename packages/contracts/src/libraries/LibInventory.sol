// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.17;

import { QueryFragment, QueryType } from "solecs/interfaces/Query.sol";
import { LibQuery } from "solecs/LibQuery.sol";
import { IWorld } from "solecs/interfaces/IWorld.sol";

import { IUint256Component } from "solecs/interfaces/IUint256Component.sol";
import { getAddressById, addressToEntity } from "solecs/utils.sol";

import { PortableComponent, ID as PortableComponentID } from "../components/PortableComponent.sol";
import { CarriedByComponent, ID as CarriedByComponentID } from "../components/CarriedByComponent.sol";
import { CarryingCapacityComponent, ID as CarryingCapacityComponentID } from "../components/CarryingCapacityComponent.sol";

library LibInventory {
  /**
   * Add an item to an inventory
   *
   * @param _components world components
   * @param _entity holder of the inventory
   * @param _item item to add
   */
  function addToInventory(IUint256Component _components, uint256 _entity, uint256 _item) internal {
    PortableComponent portableComponent = PortableComponent(getAddressById(_components, PortableComponentID));
    CarriedByComponent carriedByComponent = CarriedByComponent(getAddressById(_components, CarriedByComponentID));
    CarryingCapacityComponent carryingCapacityComponent = CarryingCapacityComponent(
      getAddressById(_components, CarryingCapacityComponentID)
    );

    require(carryingCapacityComponent.has(_entity), "LibInventory: Entity has no carrying capacity");
    require(portableComponent.has(_item), "LibInventory: Item is not portable");

    // @todo check that there is room in the inventory

    carriedByComponent.set(_item, _entity);
  }

  /**
   * Set inventory size for entity
   *
   * @param _components world components
   * @param _entity holder of the inventory
   * @param _size size of inventory
   */
  function setCarryingCapacity(IUint256Component _components, uint256 _entity, uint32 _size) internal {
    CarryingCapacityComponent carryingCapacityComponent = CarryingCapacityComponent(
      getAddressById(_components, CarryingCapacityComponentID)
    );

    carryingCapacityComponent.set(_entity, _size);
  }
}
