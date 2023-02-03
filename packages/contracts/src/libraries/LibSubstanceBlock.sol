// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.17;

import { QueryFragment, QueryType } from "solecs/interfaces/Query.sol";
import { LibQuery } from "solecs/LibQuery.sol";
import { IWorld } from "solecs/interfaces/IWorld.sol";

import { IUint256Component } from "solecs/interfaces/IUint256Component.sol";
import { getAddressById, addressToEntity } from "solecs/utils.sol";

import { PositionComponent, ID as PositionComponentID, Coord } from "../components/PositionComponent.sol";
import { MatterComponent, ID as MatterComponentID } from "../components/MatterComponent.sol";
import { PortableComponent, ID as PortableComponentID } from "../components/PortableComponent.sol";
import { SubstanceComponent, ID as SubstanceComponentID } from "../components/SubstanceComponent.sol";

library LibSubstanceBlock {
  /**
   * Create a substanceBlock entity
   *
   * @param _components World components
   * @param _substanceBlockEntity entity
   * @param _coordinates coord
   * @param _amount Matter
   */
  function create(
    IUint256Component _components,
    uint256 _substanceBlockEntity,
    Coord memory _coordinates,
    uint32 _amount
  ) internal {
    PositionComponent positionComponent = PositionComponent(getAddressById(_components, PositionComponentID));
    MatterComponent matterComponent = MatterComponent(getAddressById(_components, MatterComponentID));
    PortableComponent portableComponent = PortableComponent(getAddressById(_components, PortableComponentID));
    SubstanceComponent substanceComponent = SubstanceComponent(getAddressById(_components, SubstanceComponentID));

    positionComponent.set(_substanceBlockEntity, _coordinates);
    matterComponent.set(_substanceBlockEntity, _amount);
    portableComponent.set(_substanceBlockEntity);
    substanceComponent.set(_substanceBlockEntity, 100);
    // substanceComponent.set(Substance(100, 0));
  }

  /**
   * Destroy a substanceBlock entity
   *
   * @param _components World components
   * @param _substanceBlockEntity entity
   */
  function destroy(IUint256Component _components, uint256 _substanceBlockEntity) internal {
    MatterComponent matterComponent = MatterComponent(getAddressById(_components, MatterComponentID));
    PortableComponent portableComponent = PortableComponent(getAddressById(_components, PortableComponentID));
    SubstanceComponent substanceComponent = SubstanceComponent(getAddressById(_components, SubstanceComponentID));

    matterComponent.remove(_substanceBlockEntity);
    portableComponent.remove(_substanceBlockEntity);
    substanceComponent.remove(_substanceBlockEntity);
  }

  /**
   * Get substance block at coordinate
   *
   * @param _components World components
   * @param _coordinates Coordinates to check
   * @return unsigned array of substanceblock IDs
   */
  function getAtCoordinate(
    IUint256Component _components,
    Coord memory _coordinates
  ) internal view returns (uint256[] memory) {
    PositionComponent positionComponent = PositionComponent(getAddressById(_components, PositionComponentID));
    MatterComponent matterComponent = MatterComponent(getAddressById(_components, MatterComponentID));
    PortableComponent portableComponent = PortableComponent(getAddressById(_components, PortableComponentID));

    QueryFragment[] memory fragments = new QueryFragment[](3);
    fragments[0] = QueryFragment(QueryType.HasValue, positionComponent, abi.encode(_coordinates));
    fragments[1] = QueryFragment(QueryType.Has, matterComponent, abi.encode(0));
    fragments[2] = QueryFragment(QueryType.Has, portableComponent, abi.encode(0));

    return LibQuery.query(fragments);
  }

  /**
   * Convert substance block to energy
   *
   * @param _components World components
   * @param _substanceBlockEntity entity
   * @return unsigned energy value
   */
  function convertToEnergy(
    IUint256Component _components,
    uint256 _substanceBlockEntity
  ) internal view returns (uint32) {
    MatterComponent matterComponent = MatterComponent(getAddressById(_components, MatterComponentID));
    return matterComponent.getValue(_substanceBlockEntity) * 2;
  }
}
