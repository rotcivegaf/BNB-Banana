# Banana Idle Miner

Welcome to Banana Idle Miner, an innovative idle mining game that combines the engaging elements of idle games with the revolutionary potential of blockchain technology. In this game, players use their PC's processing power to mine unique and rare Bananas, each represented as ERC-1155 NFTs, and each ERC-1155 ID is a custom ERC20

We have created a new ERC, the ERC403, which makes it possible for each ERC1155 id to be an ERC20.

### [ID 0] Banana voting contract

The ERC1155 ID `0` is the voting contract, with which the future of the project can be decided, the community can choose:
- Create new banana ERC20 tokens
- Choose its icon
- The type of ERC20 (fee on transfer, rebasing, burning, auto liquidity, etc)
- Choose and change mining difficulty
- Etc.

### [Banana Thena Meme for Good](https://github.com/rotcivegaf/BNB-Banana/blob/main/contracts/src/bananaTokens/BananaThenaMemeGood.sol)

Using `THENA's ve3,3 gauge voting system` we have created an innovative Memecoin managed by the community and destined to promote different charities for good, some features:
- Charity: when transferring this coin a percentage(30% max) of this amount is destined to charity which will be deposited in a `thena gauge` to generate rewards, in turn also receives rewards from the `Anti-Whale Mechanisms`, these tokens are used by the `charityMultisig` to promote charity for good and finally the `charityMultisig` is managed by the voting contract(ID: 0) of the community.
- [Anti-Whale Mechanisms](https://github.com/rotcivegaf/BNB-Banana/blob/8d331c2c521a83bc4dbf40f949f7dbb7c1c47c59/contracts/src/bananaTokens/BananaThenaMemeGood.sol#L91-L101): When mining this coin if the user is a whale (has more than 10% of the totalSupply) a 50% fee is charged which goes to the `charityMultisig`.
- Use of `THENA's ve3,3 gauge voting system` to generate rewards and incentivize liquidity.
- Being a mined coin with the Anti-Whale property, a fair distribution of tokens is realized.
- To ensure the life of the project we will create an `initial liquidity pool` locked for 12 months and unlocked 10 % per month.

## Roadmap

- Implement the voting system so that the community can choose the future of the project
- [Front] Inventory page - an inventory page where the user can view his or her assets
- [Front] manage token page - where the user can manage his bananas(erc20): transfer, swap add liquidity, etc.
- Create independent minters for each erc20, for each erc115 id a different minter could be configured.
- Each erc1155 id would have an id based on the token, allowing it to have the same id in all chains and to be bridged from one chain to another.
- Add a paymaster to be able to subsidize transactions

## Table of Contents

- [Introduction](#introduction)
- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [Types of Banana](#types-of-Banana)
- [Contributing](#contributing)
- [License](#license)

## Introduction

Banana Idle Miner is designed to provide a unique gaming experience where players can earn digital assets through mining. The rarity of the Banana is determined by the complexity of the hashes found during the mining process, creating a fair and engaging reward system.

## Features

- Blockchain Integration: Utilizes Ethereum blockchain to mint and manage ERC-1155 NFTs.
- Idle Mining: Players use their computing power to mine Banana, with rarity based on hash complexity.
- Variety of Banana: Includes Normal, Steel, Golden, Crystal and Mystic.
- Decentralized Marketplace: Trade your Banana on platforms like OpenSea.
- Each ERC-1155 ID is a custom ERC20

## Installation

To run Banana Idle Miner locally, follow these steps:

Clone the Repository:
```bash
git clone git@github.com:rotcivegaf/Banana.git
cd Banana/
```

yarn install
yarn dev
go to `http://localhost:5173/`
connect your wallet


## Code

- Contract: [Banana.sol](https://github.com/rotcivegaf/BNB-Banana/blob/main/contracts/src/Banana.sol)
- Contract: [ERC403.sol](https://github.com/rotcivegaf/BNB-Banana/blob/main/contracts/src/ERC403.sol)
- Contract token: [BananaVoting.sol](https://github.com/rotcivegaf/BNB-Banana/blob/main/contracts/src/bananaTokens/BananaVoting.sol)
- Contract token: [BananaThenaMemeGood.sol](https://github.com/rotcivegaf/BNB-Banana/blob/main/contracts/src/bananaTokens/BananaThenaMemeGood.sol)
- Contract token: [BananaFeeOnTransfer.sol](https://github.com/rotcivegaf/BNB-Banana/blob/main/contracts/src/bananaTokens/BananaFeeOnTransfer.sol)
- Miner: [rust-banana-miner](https://github.com/rotcivegaf/Banana/tree/master/front/rust-banana-miner)


## Deployments

### Bsc Testnet

- Banana.sol: [0x0305768b3c1d0919a94b121E77153888C55d1326](https://testnet.bscscan.com/address/0x0305768b3c1d0919a94b121E77153888C55d1326)
    - Transaction `mintBatch`: [0x9e4ac971d264c926692d8e1ea6ea52ffa73e2664b5400e2aa5a88556f454058d](https://testnet.bscscan.com/tx/0x9e4ac971d264c926692d8e1ea6ea52ffa73e2664b5400e2aa5a88556f454058d)
    - Transaction `mintBatch`: [0x92a743d7a6d0cd7742b4c9dfd360b0415e05fccb52041a94127055f2fa086711](https://testnet.bscscan.com/tx/0x92a743d7a6d0cd7742b4c9dfd360b0415e05fccb52041a94127055f2fa086711)
- BananaVoting.sol[0]: [0xDE4C13ACc6E2B5423f5Cf8FD95234C21696F4934](https://testnet.bscscan.com/address/0xDE4C13ACc6E2B5423f5Cf8FD95234C21696F4934)
- BananaThenaMemeGood.sol[1]: [0x5704137D54f2CA861b77e7A61d66aadCeaa43B3B](https://testnet.bscscan.com/address/0x5704137D54f2CA861b77e7A61d66aadCeaa43B3B)
- BananaFeeOnTransfer.sol[2]: [0x55Bdc71C2D7EcEEF609C5871AC9D06326626E174](https://testnet.bscscan.com/address/0x55Bdc71C2D7EcEEF609C5871AC9D06326626E174)
- BananaFeeOnTransfer.sol[3]: [0x2cbcA1B2823b4eBC81CA48Cf2aD3f32eDf6BAbC3](https://testnet.bscscan.com/address/0x2cbcA1B2823b4eBC81CA48Cf2aD3f32eDf6BAbC3)
- BananaFeeOnTransfer.sol[4]: [0x36974B3807e5766dD5C6f835c3bE08dE12C544e1](https://testnet.bscscan.com/address/0x36974B3807e5766dD5C6f835c3bE08dE12C544e1)

### OPBNB Testnet Network

- Banana.sol: [0x171be1088EC661c510B3e688913A6dC039b7e470](https://opbnb-testnet.bscscan.com/address/0x171be1088EC661c510B3e688913A6dC039b7e470)
    - Transaction `mintBatch`: [0x55643a063646cce5538d362c3d95d680f461c216b1ba988ddb9a2859d824aa96](https://opbnb-testnet.bscscan.com/tx/0x55643a063646cce5538d362c3d95d680f461c216b1ba988ddb9a2859d824aa96)
    - Transaction `mintBatch`: [0x0fb7041bee2d9e985332bb0fbc79562bdafc68c3836bdc38a1f78bd95dd9cef0](https://opbnb-testnet.bscscan.com/tx/0x0fb7041bee2d9e985332bb0fbc79562bdafc68c3836bdc38a1f78bd95dd9cef0)
- BananaVoting.sol: [0x308Ceb8D7D2C46D91Eae43607Ee4C8E148301556](https://opbnb-testnet.bscscan.com/address/0x308Ceb8D7D2C46D91Eae43607Ee4C8E148301556)
- BananaFeeOnTransfer.sol[1]: [0x40B2d31DbFa1cb93D55CD0B4a2280036a6816Fb5](https://opbnb-testnet.bscscan.com/address/0x40B2d31DbFa1cb93D55CD0B4a2280036a6816Fb5)
- BananaFeeOnTransfer.sol[2]: [0x88aC16f126419D10ECc97036c87f456d8464B936](https://opbnb-testnet.bscscan.com/address/0x88aC16f126419D10ECc97036c87f456d8464B936)
- BananaFeeOnTransfer.sol[3]: [0x04e7157E00d52e4540f7bEC64ba332D6074aafb5](https://opbnb-testnet.bscscan.com/address/0x04e7157E00d52e4540f7bEC64ba332D6074aafb5)
- BananaFeeOnTransfer.sol[4]: [0xD5184d59E4FEeCD1Ff728fb0471aF36CD0704e91](https://opbnb-testnet.bscscan.com/address/0xD5184d59E4FEeCD1Ff728fb0471aF36CD0704e91)

## Usage
-----

1.  **Start Mining**:
    - This demo currently runs using Rust. You can start the mining process clicking in `Start Mining` button
    -   Adjust the number of cores used for mining in the "Cores" section.
2.  **Claim Your Banana**:
    -   Once you have mined enough, click the "Claim!" button to mint your Banana as ERC-1155 NFTs.
3.  **Check Inventory**:
    -   View your mined Banana in the Banana Contract.

Types of Banana
-------------

-   **Normal Banana**: A plain, smooth white Banana.
-   **Banana Thena Meme for Good**: powered by `THENA's ve3,3 gauge voting system`
-   **Golden Banana**: A golden Banana with a glowing aura.
-   **Crystal Banana**: A transparent Banana with multicolored reflections.
-   **Mystic Banana**: An Banana covered in ancient runes, emitting a faint purple glow.

Contributing
------------

We welcome contributions from the community! Please follow these steps to contribute:

1.  **Fork the Repository**: Click the "Fork" button on the top right corner of this repository page.
2.  **Create a Branch**: Create your feature branch (`git checkout -b feature/AmazingFeature`).
3.  **Commit Your Changes**: Commit your changes (`git commit -m 'Add some AmazingFeature'`).
4.  **Push to the Branch**: Push to the branch (`git push origin feature/AmazingFeature`).
5.  **Open a Pull Request**: Open a pull request to the `main` branch.

License
-------

This project is licensed under the MIT License.