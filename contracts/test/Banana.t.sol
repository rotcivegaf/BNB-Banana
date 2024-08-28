// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";

import {Banana} from "../src/Banana.sol";
import {BananaBase} from "../src/bananaTokens/BananaBase.sol";
import {BananaVoting} from "../src/bananaTokens/BananaVoting.sol";
import {BananaFeeOnTransfer} from "../src/bananaTokens/BananaFeeOnTransfer.sol";


contract BananaTest is Test {
    Banana banana;

    address owner = address(0xFF);
    address feeMaster = address(0xEE);
    address user = 0x889558Ea3C7b58b544EB17a6Fc04044547837a77;
    address[] bananaTokens;

    function setUp() public {
        vm.startPrank(owner);
        banana = new Banana(2);

        address bananaToken = address(new BananaVoting(address(banana)));
        bananaTokens.push(bananaToken);
        banana.addToken(bananaToken, 0);

        for(uint i = 1; i < 5; i++) {
            address _bananaToken = address(new BananaFeeOnTransfer(address(banana), feeMaster));
            bananaTokens.push(_bananaToken);
            banana.addToken(_bananaToken, i);
        }

        vm.stopPrank();
    }

    function test_constructor() public view {
        assertEq(banana.owner(), owner);
    }

    function test_mintBatch_four_ids_1() public {
        uint256[] memory nonces = new uint256[](1);

        nonces[0] = 63894049621281;
        vm.prank(user);
        banana.mintBatch(
            user,
            nonces
        );

        assertEq(banana.balanceOf(user, 0), 1);
        assertEq(banana.balanceOf(user, 1), 0);
        assertEq(banana.balanceOf(user, 2), 0);
        assertEq(banana.balanceOf(user, 3), 0);
        assertEq(banana.balanceOf(user, 4), 0);
    }
}
