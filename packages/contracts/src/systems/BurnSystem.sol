// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;

import "solecs/System.sol";
import { IWorld } from "solecs/interfaces/IWorld.sol";
import { getAddressById, addressToEntity } from "solecs/utils.sol";

import { LibCore } from "../libraries/LibCore.sol";
import { LibMap } from "../libraries/LibMap.sol";
import { LibMove } from "../libraries/LibMove.sol";
import { LibInventory } from "../libraries/LibInventory.sol";
import { LibAbility } from "../libraries/LibAbility.sol";
import { LibConfig } from "../libraries/LibConfig.sol";
import { LibSubstanceBlock } from "../libraries/LibSubstanceBlock.sol";
import { LibBurn } from "../libraries/LibBurn.sol";

import { GameConfig } from "../components/GameConfigComponent.sol";
import { ID as AbilityBurnComponentID } from "../components/AbilityBurnComponent.sol";

import { Activity } from "../utils/constants.sol";

uint256 constant ID = uint256(keccak256("system.Burn"));

contract BurnSystem is System {
  constructor(IWorld _world, address _components) System(_world, _components) {}

  function execute(bytes memory arguments) public returns (bytes memory) {
    uint256 _substanceBlockEntity = abi.decode(arguments, (uint256));
    uint256 coreEntity = addressToEntity(msg.sender);

    GameConfig memory gameConfig = LibConfig.getGameConfig(components);

    require(LibCore.isSpawned(components, coreEntity), "BurnSystem: core does not exist");
    require(LibCore.isReady(components, coreEntity), "BurnSystem: core is in cooldown");
    require(!LibCore.isCommitted(components, coreEntity), "BurnSystem: core is committed");
    require(LibCore.checkEnergy(components, coreEntity, gameConfig.burnCost), "BurnSystem: not enough energy");
    require(LibSubstanceBlock.isSubstanceBlock(components, _substanceBlockEntity), "BurnSystem: not substanceBlock");

    uint256 baseEntity = LibInventory.getCarriedBy(components, coreEntity);

    uint32 abilityCount = LibAbility.checkInventoryForAbility(components, baseEntity, AbilityBurnComponentID);
    require(abilityCount > 0, "BurnSystem: no item with AbilityBurn");

    if (LibMove.hasPosition(components, _substanceBlockEntity)) {
      require(
        LibMap.isAdjacent(
          LibMove.getPosition(components, baseEntity),
          LibMove.getPosition(components, _substanceBlockEntity)
        ),
        "BurnSystem: not adjacent"
      );
    } else {
      require(
        LibInventory.isCarriedBy(components, _substanceBlockEntity, baseEntity),
        "BurnSystem: not carried by entity"
      );
    }

    LibBurn.burn(components, _substanceBlockEntity);
    LibCore.decreaseEnergy(components, coreEntity, gameConfig.burnCost);
  }

  function executeTyped(uint256 _substanceBlockEntity) public returns (bytes memory) {
    return execute(abi.encode(_substanceBlockEntity));
  }
}
