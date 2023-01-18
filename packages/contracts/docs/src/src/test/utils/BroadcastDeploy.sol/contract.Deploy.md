# Deploy

[Git Source](https://github.com/Moving-Castles/eat-drain-arson/blob/7bfd8b7722dbe81e95349eb300f1195a0dad2f0a/src/test/utils/BroadcastDeploy.sol)

**Inherits:**
DSTest

## State Variables

### vm

```solidity
Cheats internal immutable vm = Cheats(HEVM_ADDRESS);
```

## Functions

### deploy

```solidity
function deploy(
  address _deployer,
  address _world,
  bool _reuseComponents
) public returns (address world, uint256 initialBlockNumber);
```

### upgradeSystems

```solidity
function upgradeSystems(address _deployer, address _world) public returns (address world, uint256 initialBlockNumber);
```
