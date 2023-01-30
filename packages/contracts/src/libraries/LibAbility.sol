// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.17;

import { QueryFragment, QueryType } from "solecs/interfaces/Query.sol";
import { LibQuery } from "solecs/LibQuery.sol";
import { IWorld } from "solecs/interfaces/IWorld.sol";
import { IComponent } from "solecs/interfaces/IComponent.sol";

import { IUint256Component } from "solecs/interfaces/IUint256Component.sol";
import { getComponentById, getAddressById, addressToEntity } from "solecs/utils.sol";

import { LibInventory } from "../libraries/LibInventory.sol";

library LibAbility {
  /**
   * Give ability
   *
   * @param _components World components
   * @param _entity Entity
   * @param _componentId AbilityComponent
   */
  function giveAbility(IUint256Component _components, uint256 _entity, uint256 _componentId) internal {
    IComponent abilityComponent = getComponentById(_components, _componentId);
    abilityComponent.set(_entity, abi.encode(1));
  }

  /**
   * Remove ability
   *
   * @param _components World components
   * @param _entity Entity
   * @param _componentId AbilityComponent
   */
  function removeAbility(IUint256Component _components, uint256 _entity, uint256 _componentId) internal {
    IComponent abilityComponent = getComponentById(_components, _componentId);
    abilityComponent.remove(_entity);
  }

  /**
   * Check entity for ability
   *
   * @param _components World components
   * @param _entity Entity
   * @param _componentId AbilityComponent
   * @return
   */
  function checkEntityForAbility(
    IUint256Component _components,
    uint256 _entity,
    uint256 _componentId
  ) internal view returns (bool) {
    IComponent abilityComponent = getComponentById(_components, _componentId);
    return abilityComponent.has(_entity);
  }

  /**
   * Check inventory for ability
   *
   * @param _components World components
   * @param _baseEntity Base Entity
   * @param _componentId AbilityComponent
   * @return bool does the inventory contain an entity with this ability?
   */
  function checkInventoryForAbility(
    IUint256Component _components,
    uint256 _baseEntity,
    uint256 _componentId
  ) internal view returns (bool) {
    uint256[] memory inventory = LibInventory.getInventory(_components, _baseEntity);
    for (uint256 i; i < inventory.length; i++) {
      if (checkEntityForAbility(_components, inventory[i], _componentId)) return true;
    }
    return false;
  }
}
