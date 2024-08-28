// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import "openzeppelin/contracts/token/ERC20/ERC20.sol";
import "openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";
import "openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";
import {ITokenBase} from "../ITokenBase.sol";

contract BananaVoting is ITokenBase, ERC20, ERC20Permit, ERC20Votes {
    // owner is the 403 contract available to `mint` and `erc1155Transfer`
    address private immutable _owner;

    constructor(
        address __owner
    ) ERC20("BananaGovernance", "BNNGOV") ERC20Permit("BNNGOV") {
        _owner = __owner;
    }

    function erc1155Transfer(address from, address to, uint256 amount) external virtual {
        require(msg.sender == _owner, "!owner");

        super._update(from, to, amount);
    }

    function mint(address to, uint256 amount) external virtual {
        require(msg.sender == _owner, "!owner");
        unchecked {
            _mint(to, amount * decimals());
        }
    }

    // Overrides IERC6372 functions to make the token & governor timestamp-based

    function clock() public view override returns (uint48) {
        return uint48(block.timestamp);
    }

    // solhint-disable-next-line func-name-mixedcase
    function CLOCK_MODE() public pure override returns (string memory) {
        return "mode=timestamp";
    }

    // The functions below are overrides required by Solidity.

    function _update(address from, address to, uint256 amount) internal override(ERC20, ERC20Votes) {
        super._update(from, to, amount);
    }

    function nonces(address owner) public view virtual override(ERC20Permit, Nonces) returns (uint256) {
        return super.nonces(owner);
    }
}