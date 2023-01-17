// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.17;
import "std-contracts/components/Uint256ArrayComponent.sol";

uint256 constant ID = uint256(keccak256("component.Inventory"));

contract InventoryComponent is Uint256ArrayComponent {
  constructor(address world) Uint256ArrayComponent(world, ID) {}
}
