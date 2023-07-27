# Utilities

[Git Source](https://github.com/Moving-Castles/eat-drain-arson/blob/7bfd8b7722dbe81e95349eb300f1195a0dad2f0a/src/test/utils/Utilities.sol)

**Inherits:**
DSTest

## State Variables

### vm

```solidity
Vm internal immutable vm = Vm(HEVM_ADDRESS);
```

### nextUser

```solidity
bytes32 internal nextUser = keccak256(abi.encodePacked("user address"));
```

## Functions

### getNextUserAddress

```solidity
function getNextUserAddress() external returns (address payable);
```

### createUsers

```solidity
function createUsers(uint256 userNum) external returns (address payable[] memory);
```

### mineBlocks

```solidity
function mineBlocks(uint256 numBlocks) external;
```
