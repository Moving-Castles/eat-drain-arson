# Cheats

[Git Source](https://github.com/Moving-Castles/eat-drain-arson/blob/7bfd8b7722dbe81e95349eb300f1195a0dad2f0a/src/test/utils/Cheats.sol)

## Functions

### warp

```solidity
function warp(uint256) external;
```

### roll

```solidity
function roll(uint256) external;
```

### fee

```solidity
function fee(uint256) external;
```

### coinbase

```solidity
function coinbase(address) external;
```

### load

```solidity
function load(address, bytes32) external returns (bytes32);
```

### store

```solidity
function store(address, bytes32, bytes32) external;
```

### sign

```solidity
function sign(uint256, bytes32) external returns (uint8, bytes32, bytes32);
```

### addr

```solidity
function addr(uint256) external returns (address);
```

### ffi

```solidity
function ffi(string[] calldata) external returns (bytes memory);
```

### prank

```solidity
function prank(address) external;
```

### startPrank

```solidity
function startPrank(address) external;
```

### prank

```solidity
function prank(address, address) external;
```

### startPrank

```solidity
function startPrank(address, address) external;
```

### stopPrank

```solidity
function stopPrank() external;
```

### deal

```solidity
function deal(address, uint256) external;
```

### etch

```solidity
function etch(address, bytes calldata) external;
```

### expectRevert

```solidity
function expectRevert() external;
```

### expectRevert

```solidity
function expectRevert(bytes calldata) external;
```

### expectRevert

```solidity
function expectRevert(bytes4) external;
```

### record

```solidity
function record() external;
```

### accesses

```solidity
function accesses(address) external returns (bytes32[] memory reads, bytes32[] memory writes);
```

### expectEmit

```solidity
function expectEmit(bool, bool, bool, bool) external;
```

### expectEmit

```solidity
function expectEmit(bool, bool, bool, bool, address) external;
```

### mockCall

```solidity
function mockCall(address, bytes calldata, bytes calldata) external;
```

### clearMockedCalls

```solidity
function clearMockedCalls() external;
```

### expectCall

```solidity
function expectCall(address, bytes calldata) external;
```

### getCode

```solidity
function getCode(string calldata) external returns (bytes memory);
```

### label

```solidity
function label(address, string calldata) external;
```

### assume

```solidity
function assume(bool) external;
```

### setNonce

```solidity
function setNonce(address, uint64) external;
```

### getNonce

```solidity
function getNonce(address) external returns (uint64);
```

### chainId

```solidity
function chainId(uint256) external;
```

### broadcast

```solidity
function broadcast() external;
```

### broadcast

```solidity
function broadcast(address) external;
```

### startBroadcast

```solidity
function startBroadcast(address) external;
```

### stopBroadcast

```solidity
function stopBroadcast() external;
```
