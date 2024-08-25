# CDP Stablecoin

A DeFi protocol where users can deposit collateral in exchange for a decentralized stablecoin.

The stablecoin  has exogenous collateral (ETH or WBTC). It attempts to maintain peg to the USD and it is algorithmically stable.

The protocol uses [Chainlink Price Feeds](https://docs.chain.link/data-feeds) to get the real-time price of assets.

### Requirements
- [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
- [foundry](https://getfoundry.sh/)

### Installation
```bash
git clone https://github.com/KhadijaAhmadova/cdp-stablecoin
cd cdp-stablecoin
```
To install dependencies run
```bash
make install
```
In `foundry.toml` add
```bash
remappings = [
    "@chainlink/contracts/=lib/chainlink-brownie-contracts/contracts/",
    "@openzeppelin/contracts=lib/openzeppelin-contracts/contracts",
]
```
### Usage
Start a local node and deploy.
```bash
make anvil
make deploy
```
`make deploy` will default to the local node.

To deploy to Ethereum Sepolia set SEPOLIA_RPC_URL and PRIVATE_KEY as environment variables.
```bash
make deploy ARGS="--network sepolia"
```