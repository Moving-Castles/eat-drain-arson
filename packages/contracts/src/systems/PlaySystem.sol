// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;

import "solecs/System.sol";
import { IWorld } from "solecs/interfaces/IWorld.sol";
import { getAddressById, addressToEntity } from "solecs/utils.sol";

import { LibCore } from "../libraries/LibCore.sol";
import { LibCooldown } from "../libraries/LibCooldown.sol";
import { LibInventory } from "../libraries/LibInventory.sol";
import { LibAbility } from "../libraries/LibAbility.sol";
import { LibConfig } from "../libraries/LibConfig.sol";

import { GameConfig } from "../components/GameConfigComponent.sol";
import { ID as AbilityPlayComponentID } from "../components/AbilityPlayComponent.sol";

import { Activity } from "../utils/constants.sol";

uint256 constant ID = uint256(keccak256("system.Play"));

contract PlaySystem is System {
  constructor(IWorld _world, address _components) System(_world, _components) {}

  function execute(bytes memory arguments) public returns (bytes memory) {
    uint256 coreEntity = addressToEntity(msg.sender);

    GameConfig memory gameConfig = LibConfig.getGameConfig(components);

    require(LibCore.isSpawned(components, coreEntity), "PlaySystem: entity does not exist");
    require(LibCooldown.isReady(components, coreEntity), "PlaySystem: entity is in cooldown");

    uint256 baseEntity = LibInventory.getCarriedBy(components, coreEntity);

    uint32 abilityCount = LibAbility.checkInventoryForAbilityNumber(components, baseEntity, AbilityPlayComponentID);
    require(abilityCount > 0, "PlaySystem: no item with AbilityPlay");

    if (LibCore.isCommitted(components, coreEntity)) {
      LibCore.uncommit(components, coreEntity);
    } else {
      require(LibCore.checkEnergy(components, coreEntity, gameConfig.playCost), "PlaySystem: not enough energy");
      LibCore.commit(components, coreEntity, Activity.Play);
      LibCore.decreaseEnergy(components, coreEntity, gameConfig.playCost);
    }
  }

  function executeTyped() public returns (bytes memory) {
    return execute(abi.encode());
  }
}
