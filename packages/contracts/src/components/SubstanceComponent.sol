// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.17;
import "std-contracts/components/Uint32Component.sol";

uint256 constant ID = uint256(keccak256("component.Substance"));

contract SubstanceComponent is Uint32Component {
  constructor(address world) Uint32Component(world, ID) {}
}
