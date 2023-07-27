# LibDeploy

[Git Source](https://github.com/Moving-Castles/eat-drain-arson/blob/7bfd8b7722dbe81e95349eb300f1195a0dad2f0a/src/libraries/LibDeploy.sol)

## Functions

### deploy

```solidity
function deploy(address _deployer, address _world, bool _reuseComponents) internal returns (DeployResult memory result);
```

### authorizeWriter

```solidity
function authorizeWriter(IUint256Component components, uint256 componentId, address writer) internal;
```

### deploySystems

Deploy systems to the given world.
If `init` flag is set, systems with `initialize` setting in `deploy.json` will be executed.

```solidity
function deploySystems(address _world, bool init) internal;
```
