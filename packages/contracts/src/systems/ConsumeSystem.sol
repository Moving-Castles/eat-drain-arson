// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;
import "solecs/System.sol";
import { IWorld } from "solecs/interfaces/IWorld.sol";
import { getAddressById, addressToEntity } from "solecs/utils.sol";

import { LibCore } from "../libraries/LibCore.sol";
import { LibCooldown } from "../libraries/LibCooldown.sol";
import { LibInventory } from "../libraries/LibInventory.sol";
import { LibSubstanceBlock } from "../libraries/LibSubstanceBlock.sol";
import { LibAbility } from "../libraries/LibAbility.sol";

import { ID as AbilityConsumeComponentID } from "../components/AbilityConsumeComponent.sol";

uint256 constant ID = uint256(keccak256("system.Consume"));

contract ConsumeSystem is System {
  constructor(IWorld _world, address _components) System(_world, _components) {}

  function execute(bytes memory arguments) public returns (bytes memory) {
    uint256 _substanceBlockEntity = abi.decode(arguments, (uint256));
    uint256 coreEntity = addressToEntity(msg.sender);

    require(LibCore.isSpawned(components, coreEntity), "ConsumeSystem: entity does not exist");
    require(LibCooldown.isReady(components, coreEntity), "ConsumeSystem: entity is in cooldown");
    require(!LibCore.isCommitted(components, coreEntity), "ConsumeSystem: entity is committed");

    uint256 baseEntity = LibInventory.getCarriedBy(components, coreEntity);

    require(LibInventory.isCarriedBy(components, _substanceBlockEntity, baseEntity), "ConsumeSystem: not carried");

    uint32 abilityCount = LibAbility.checkInventoryForAbilityNumber(components, baseEntity, AbilityConsumeComponentID);
    require(abilityCount > 0, "ConsumeSystem: no item with AbilityConsume");

    uint32 energy = LibSubstanceBlock.convertToEnergy(components, _substanceBlockEntity, abilityCount);
    LibCore.increaseEnergy(components, coreEntity, energy);

    LibInventory.removeFromInventory(components, _substanceBlockEntity);
    LibSubstanceBlock.destroy(components, _substanceBlockEntity);

    // @todo: add piss block
  }

  function executeTyped(uint256 _substanceBlockEntity) public returns (bytes memory) {
    return execute(abi.encode(_substanceBlockEntity));
  }
}
