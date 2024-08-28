// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import "forge-std/Script.sol";
import {Banana} from "../src/Banana.sol";
import {BananaVoting} from "../src/bananaTokens/BananaVoting.sol";
import {BananaFeeOnTransfer} from "../src/bananaTokens/BananaFeeOnTransfer.sol";

contract Deploy is Script {
    function run() public {
        vm.startBroadcast();
        Banana banana = new Banana(6);
        address _banana = address(banana);

        address token0 = address(new BananaVoting(_banana));
        banana.addToken(token0, 0);
        address token1 = address(new BananaFeeOnTransfer(_banana, msg.sender));
        banana.addToken(token1, 1);
        address token2 = address(new BananaFeeOnTransfer(_banana, msg.sender));
        banana.addToken(token2, 2);
        address token3 = address(new BananaFeeOnTransfer(_banana, msg.sender));
        banana.addToken(token3, 3);
        address token4 = address(new BananaFeeOnTransfer(_banana, msg.sender));
        banana.addToken(token4, 4);

        console.log("banana:", _banana);
        console.log("token0:", token0);
        console.log("token1:", token1);
        console.log("token2:", token2);
        console.log("token3:", token3);
        console.log("token4:", token4);

        vm.stopBroadcast();
    }
}
/*
forge script \
  script/Deploy.sol:Deploy \
  --rpc-url https://opbnb-testnet-rpc.bnbchain.org \
  --private-key  \
  --interactives 1 \
  -vvv \
  --broadcast
  
BSC:
    banana: 0xB82A4C77a57A08109D9EC0f338a944f1D4f7229B
    token0: 0x4f818C1e8ed8852eD5c84D4198b5E2659008586a
    token1: 0x3Ec5C0A31D779cdEd116741bc3E0f2713E39CA14
    token2: 0xAd43AbaeD15e41176F666DF2935f1249560e4456
    token3: 0x617f1025F1e41Df21d02b35a2DbbA1a0725420ED
    token4: 0x9d8D5DDc5596E821816c0f31c7A1dD2ef1C1C5AA
OPBSC:
    banana: 0x171be1088EC661c510B3e688913A6dC039b7e470
    token0: 0x308Ceb8D7D2C46D91Eae43607Ee4C8E148301556
    token1: 0x40B2d31DbFa1cb93D55CD0B4a2280036a6816Fb5
    token2: 0x88aC16f126419D10ECc97036c87f456d8464B936
    token3: 0x04e7157E00d52e4540f7bEC64ba332D6074aafb5
    token4: 0xD5184d59E4FEeCD1Ff728fb0471aF36CD0704e91



forge verify-contract \
    --chain-id 5611 \
    --num-of-optimizations 200 \
    --watch 0x18fCCdeC6584f1f39201F62C00EE6299ed8433E2 \
    src/Banana.sol:Banana --constructor-args $(cast abi-encode "constructor(uint256)" 6) \
    --etherscan-api-key 

forge verify-contract \
    --chain-id 5611 \
    --num-of-optimizations 200 \
    --watch 0xd94b83AaFd0303E8Ec001C985aeF447CE8081EE7 \
    src/bananaTokens/BananaVoting.sol:BananaVoting --constructor-args $(cast abi-encode "constructor(address)" 0x18fCCdeC6584f1f39201F62C00EE6299ed8433E2) \
    --etherscan-api-key ""

forge verify-contract \
    --chain-id 5611 \
    --num-of-optimizations 200 \
    --watch 0x97083D15DFbB424c0b7c26BD011cC908D3845700 \
    src/bananaTokens/BananaFeeOnTransfer.sol:BananaFeeOnTransfer --constructor-args $(cast abi-encode "constructor(address,address)" 0x18fCCdeC6584f1f39201F62C00EE6299ed8433E2 0x889558Ea3C7b58b544EB17a6Fc04044547837a77) \
    --etherscan-api-key ""
    
    

    */