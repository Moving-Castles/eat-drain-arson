// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.17;

import { QueryFragment, QueryType } from "solecs/interfaces/Query.sol";
import { LibQuery } from "solecs/LibQuery.sol";
import { IWorld } from "solecs/interfaces/IWorld.sol";

import { IUint256Component } from "solecs/interfaces/IUint256Component.sol";
import { getAddressById, addressToEntity } from "solecs/utils.sol";

import { PositionComponent, ID as PositionComponentID, Coord } from "../components/PositionComponent.sol";
import { MatterComponent, ID as MatterComponentID } from "../components/MatterComponent.sol";

library LibResource {
  /**
   * Create a resource entity
   *
   * @param _components World components
   * @param _resourceEntity entity
   * @param _coordinates coord
   * @param _amount Matter
   */
  function create(
    IUint256Component _components,
    uint256 _resourceEntity,
    Coord memory _coordinates,
    uint32 _amount
  ) internal {
    PositionComponent positionComponent = PositionComponent(getAddressById(_components, PositionComponentID));
    MatterComponent matterComponent = MatterComponent(getAddressById(_components, MatterComponentID));

    positionComponent.set(_resourceEntity, _coordinates);
    matterComponent.set(_resourceEntity, _amount);
  }

  /**
   * Get resource entity at coordinate
   *
   * @param _components World components
   * @param _coordinates Coordinates to check
   * @return unsigned Id of resource entity, 0 if none
   */
  function getAtCoordinate(IUint256Component _components, Coord memory _coordinates) internal view returns (uint256) {
    PositionComponent positionComponent = PositionComponent(getAddressById(_components, PositionComponentID));
    MatterComponent matterComponent = MatterComponent(getAddressById(_components, MatterComponentID));

    QueryFragment[] memory fragments = new QueryFragment[](2);
    fragments[0] = QueryFragment(QueryType.HasValue, positionComponent, abi.encode(_coordinates));
    fragments[1] = QueryFragment(QueryType.Has, matterComponent, abi.encode(0));

    uint256[] memory results = LibQuery.query(fragments);

    if (results.length > 0) return results[0];
    return 0;
  }

  /**
   * Check matter
   *
   * @param _components World components
   * @param _entity Core entity
   * @param _amount Amount to check against
   * @return bool False if the resource does not have enough matter
   */
  function checkMatter(IUint256Component _components, uint256 _entity, uint32 _amount) internal view returns (bool) {
    MatterComponent matterComponent = MatterComponent(getAddressById(_components, MatterComponentID));
    uint32 currentMatter = matterComponent.getValue(_entity);
    if (currentMatter < _amount) return false;
    return true;
  }

  /**
   * Decrease matter
   *
   * @param _components World components
   * @param _entity Core entity
   * @param _amount Amount to decrease by
   * @return bool False if the resource does not have enough matter
   */
  function decreaseMatter(IUint256Component _components, uint256 _entity, uint32 _amount) internal returns (bool) {
    MatterComponent matterComponent = MatterComponent(getAddressById(_components, MatterComponentID));
    uint32 currentMatter = matterComponent.getValue(_entity);
    if (currentMatter < _amount) return false;
    matterComponent.set(_entity, currentMatter - _amount);
    return true;
  }
}
