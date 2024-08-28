// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {ERC20} from "solmate/tokens/ERC20.sol";
import {LibString} from "solady/utils/LibString.sol";
import {ITokenBase} from "../ITokenBase.sol";

abstract contract BananaBase is ITokenBase, ERC20 {
    // owner is the 403 contract available to `mint` and `erc1155Transfer`
    address internal immutable _owner;
    uint256 internal immutable decimalsMul;

    constructor(
        string memory _name,
        string memory _symbol,
        uint8 _decimals,
        address __owner
    ) ERC20(_name, _symbol, _decimals) {
        _owner = __owner;
        _name = string.concat("Banana-", _name);
        _symbol = string.concat("BNN-", _symbol);
        decimalsMul = 10 ** _decimals;
    }

    function erc1155Transfer(address from, address to, uint256 amount) external virtual {
        require(msg.sender == _owner, "!owner");
        unchecked {
            amount *= decimalsMul;
        }
        balanceOf[from] -= amount;

        // Cannot overflow because the sum of all user
        // balances can't exceed the max uint256 value.
        unchecked {
            balanceOf[to] += amount;
        }

        emit Transfer(from, to, amount);
    }

    function mint(address to, uint256 amount) external virtual {
        require(msg.sender == _owner, "!owner");
        unchecked {
            _mint(to, amount * decimalsMul);
        }
    }
}
