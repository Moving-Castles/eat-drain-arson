# LibInventory

[Git Source](https://github.com/Moving-Castles/eat-drain-arson/blob/7bfd8b7722dbe81e95349eb300f1195a0dad2f0a/src/libraries/LibInventory.sol)

## Functions

### addToInventory

add an item to an inventory

```solidity
function addToInventory(IUint256Component _components, uint256 _entity, uint256 _item) public;
```

**Parameters**

| Name          | Type                | Description             |
| ------------- | ------------------- | ----------------------- |
| `_components` | `IUint256Component` | world components        |
| `_entity`     | `uint256`           | holder of the inventory |
| `_item`       | `uint256`           | item to add             |
