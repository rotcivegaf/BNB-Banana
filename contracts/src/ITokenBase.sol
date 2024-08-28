// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

interface ITokenBase {
    function erc1155Transfer(address from, address to, uint256 amount) external;
    function mint(address to, uint256 amount) external;
}
