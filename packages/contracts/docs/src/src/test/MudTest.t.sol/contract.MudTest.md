# MudTest

[Git Source](https://github.com/Moving-Castles/eat-drain-arson/blob/7bfd8b7722dbe81e95349eb300f1195a0dad2f0a/src/test/MudTest.t.sol)

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

### alice

```solidity
address payable internal alice;
```

### bob

```solidity
address payable internal bob;
```

### eve

```solidity
address payable internal eve;
```

### deployer

```solidity
address internal deployer;
```

### world

```solidity
IWorld internal world;
```

### components

```solidity
IUint256Component components;
```

### systems

```solidity
IUint256Component systems;
```

### deploy

```solidity
Deploy internal deploy = new Deploy();
```

### positionComponent

```solidity
PositionComponent positionComponent;
```

### energyComponent

```solidity
EnergyComponent energyComponent;
```

### creationBlockComponent

```solidity
CreationBlockComponent creationBlockComponent;
```

### readyBlockComponent

```solidity
ReadyBlockComponent readyBlockComponent;
```

### controlComponent

```solidity
ControlComponent controlComponent;
```

### portableComponent

```solidity
PortableComponent portableComponent;
```

### inventoryComponent

```solidity
InventoryComponent inventoryComponent;
```

## Functions

### component

```solidity
function component(uint256 id) public view returns (address);
```

### system

```solidity
function system(uint256 id) public view returns (address);
```

### setUp

```solidity
function setUp() public;
```
