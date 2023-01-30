// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.17;
import "std-contracts/components/BoolComponent.sol";

uint256 constant ID = uint256(keccak256("component.AbilityExtract"));

contract AbilityExtractComponent is BoolComponent {
  constructor(address world) BoolComponent(world, ID) {}
}
