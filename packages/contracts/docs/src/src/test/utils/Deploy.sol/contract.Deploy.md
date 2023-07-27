# Deploy

[Git Source](https://github.com/Moving-Castles/eat-drain-arson/blob/7bfd8b7722dbe81e95349eb300f1195a0dad2f0a/src/test/utils/Deploy.sol)

**Inherits:**
DSTest

## State Variables

### vm

```solidity
Cheats internal immutable vm = Cheats(HEVM_ADDRESS);
```

### utils

```solidity
Utilities internal immutable utils = new Utilities();
```

### deployer

```solidity
address public deployer;
```

### world

```solidity
IWorld public world;
```

## Functions

### deploy

```solidity
function deploy(address _deployer, address _world, bool _reuseComponents) public returns (IWorld);
```
