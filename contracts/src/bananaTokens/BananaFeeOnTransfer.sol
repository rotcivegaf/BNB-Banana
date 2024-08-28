// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {BananaBase} from "./BananaBase.sol";


contract BananaFeeOnTransfer is BananaBase {
    address public immutable feeMaster;
    uint256 private constant BASE = 10000;
    uint256 public fee = 300; // 0.3 %

    constructor(
        address _owner,
        address _feeMaster
    ) BananaBase("BananaFeeOnTransfer", "BNNFoT", 18, _owner) {
        feeMaster = _feeMaster;
    }

    function transfer(address to, uint256 amount) public override returns (bool) {
        uint256 feeAmount = amount * fee / BASE;
        super.transfer(feeMaster, feeAmount);
        super.transfer(to, amount - feeAmount);

        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public override returns (bool) {
        uint256 feeAmount = amount * fee / BASE;
        super.transferFrom(from, feeMaster, feeAmount);
        super.transferFrom(from, to, amount - feeAmount);

        return true;
    }

    function setFee(uint256 _fee) external {
        require(msg.sender == feeMaster, "Not fee master");
        require(_fee < 1000, "Fee should be less than 10%");

        fee = _fee;
    }
}