// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.17;

import { QueryFragment, QueryType } from "solecs/interfaces/Query.sol";
import { LibQuery } from "solecs/LibQuery.sol";
import { IWorld } from "solecs/interfaces/IWorld.sol";

import { IUint256Component } from "solecs/interfaces/IUint256Component.sol";
import { getAddressById, addressToEntity } from "solecs/utils.sol";

import { LibArray } from "./LibArray.sol";

import { PortableComponent, ID as PortableComponentID } from "../components/PortableComponent.sol";
import { InventoryComponent, ID as InventoryComponentID } from "../components/InventoryComponent.sol";

library LibInventory {
  /**
   * Add an item to an inventory
   *
   * @param _components World components
   * @param _entity Holder of the inventory
   * @param _item Item to add
   */
  function addToInventory(IUint256Component _components, uint256 _entity, uint256 _item) internal {
    PortableComponent portableComponent = PortableComponent(getAddressById(_components, PortableComponentID));
    InventoryComponent inventoryComponent = InventoryComponent(getAddressById(_components, InventoryComponentID));

    require(portableComponent.has(_item), "item can not be added to inventory");

    if (inventoryComponent.has(_entity)) {
      uint256 inventoryLength = inventoryComponent.getValue(_entity).length;
      require(inventoryLength <= 10, "inventory is full");

      uint256[] memory oldArray = inventoryComponent.getValue(_entity);
      uint256[] memory newArray = new uint256[](inventoryLength + 1);

      for (uint256 i = 0; i < inventoryLength; i++) {
        newArray[i] = oldArray[i];
      }

      newArray[inventoryLength] = _item;
      inventoryComponent.set(_entity, newArray);
    } else {
      uint256[] memory tempArray = new uint256[](1);
      tempArray[0] = _item;
      inventoryComponent.set(_entity, tempArray);
    }
  }
}
