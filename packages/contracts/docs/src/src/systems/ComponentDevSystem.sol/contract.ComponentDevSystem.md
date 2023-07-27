# ComponentDevSystem

[Git Source](https://github.com/Moving-Castles/eat-drain-arson/blob/7bfd8b7722dbe81e95349eb300f1195a0dad2f0a/src/systems/ComponentDevSystem.sol)

**Inherits:**
System

## Functions

### constructor

```solidity
constructor(IWorld _world, address _components) System(_world, _components);
```

### requirement

```solidity
function requirement(bytes memory) public view returns (bytes memory);
```

### execute

```solidity
function execute(bytes memory arguments) public returns (bytes memory);
```

### executeTyped

```solidity
function executeTyped(uint256 componentId, uint256 entity, bytes memory value) public returns (bytes memory);
```
