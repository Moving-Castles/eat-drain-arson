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
   * Get a base entity's inventory
   *
   * @param _components world components
   * @param _baseEntity holder of the inventory
   * @return array the inventory
   */
  function getInventory(IUint256Component _components, uint256 _baseEntity) internal view returns (uint256[] memory) {
    CarriedByComponent carriedByComponent = CarriedByComponent(getAddressById(_components, CarriedByComponentID));

    QueryFragment[] memory fragments = new QueryFragment[](1);
    fragments[0] = QueryFragment(QueryType.HasValue, carriedByComponent, abi.encode(_baseEntity));

    return LibQuery.query(fragments);
  }

  /**
   * Get a base entity's inventory
   *
   * @param _components world components
   * @param _baseEntity holder of the inventory
   * @return length length of inventory
   */
  function getInventorySize(IUint256Component _components, uint256 _baseEntity) internal view returns (uint256) {
    return getInventory(_components, _baseEntity).length;
  }

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

    require(carryingCapacityComponent.has(_entity), "LibInventory: entity has no carrying capacity");
    require(portableComponent.has(_item), "LibInventory: item is not portable");
    require(
      getInventorySize(_components, _entity) < carryingCapacityComponent.getValue(_entity),
      "LibInventory: inventory is full"
    );

    carriedByComponent.set(_item, _entity);
  }

  /**
   * Remove an item from an inventory
   *
   * @param _components world components
   * @param _entity item to remove
   */
  function removeFromInventory(IUint256Component _components, uint256 _entity) internal {
    CarriedByComponent carriedByComponent = CarriedByComponent(getAddressById(_components, CarriedByComponentID));
    carriedByComponent.remove(_entity);
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

  /**
   * Make entity portable
   *
   * @param _components world components
   * @param _entity portable entity
   */
  function makePortable(IUint256Component _components, uint256 _entity) internal {
    PortableComponent portableComponent = PortableComponent(getAddressById(_components, PortableComponentID));
    return portableComponent.set(_entity);
  }

  /**
   * Check if entity is portable
   *
   * @param _components world components
   * @param _entity entity to check
   * @return bool is the entity portable?
   */
  function isPortable(IUint256Component _components, uint256 _entity) internal view returns (bool) {
    PortableComponent portableComponent = PortableComponent(getAddressById(_components, PortableComponentID));
    return portableComponent.has(_entity);
  }

  /**
   * Check if one entity is carried by another
   *
   * @param _components world components
   * @param _portableEntity Carried
   * @param _baseEntity Carrier
   * @return bool
   */
  function isCarriedBy(
    IUint256Component _components,
    uint256 _portableEntity,
    uint256 _baseEntity
  ) internal view returns (bool) {
    CarriedByComponent carriedByComponent = CarriedByComponent(getAddressById(_components, CarriedByComponentID));
    return carriedByComponent.getValue(_portableEntity) == _baseEntity;
  }

  /**
   * Get carrying entity
   *
   * @param  _components,
   * @param _portableEntity Carried
   * @return unsigned carrying entity
   */
  function getCarriedBy(IUint256Component _components, uint256 _portableEntity) internal view returns (uint256) {
    CarriedByComponent carriedByComponent = CarriedByComponent(getAddressById(_components, CarriedByComponentID));
    return carriedByComponent.getValue(_portableEntity);
  }
}
