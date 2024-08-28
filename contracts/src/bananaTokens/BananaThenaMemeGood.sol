// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {BananaBase} from "./BananaBase.sol";


interface IThenaGauge {
    function depositAll() external;
    
    function withdraw(uint256 amount) external;
    function withdrawAllAndHarvest() external;
    function getReward() external;

    function emergencyWithdraw() external;
}

contract BananaThenaMemeGood is BananaBase {
    uint256 private constant BASE = 10000;

    address public immutable charityMultisig;
    uint256 public charityFee = 300; // 3 %

    IThenaGauge public gauge;

    constructor(
        address _owner,
        address _charityMultisig
    ) BananaBase("Banana-Thena-MemeGood", "BNNTMG", 18, _owner) {
        charityMultisig = _charityMultisig;
    }

    function transfer(address to, uint256 amount) public override returns (bool) {
        uint256 charityFeeAmount = amount * charityFee / BASE;

        if (address(gauge) != address(0)) {
            super.transfer(address(this), charityFeeAmount);
            gauge.depositAll();
        } else {
            super.transfer(charityMultisig, charityFeeAmount);
        }
        
        super.transfer(to, amount - charityFeeAmount);

        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public override returns (bool) {
        uint256 charityFeeAmount = amount * charityFee / BASE;

        if (address(gauge) != address(0)) {
            super.transferFrom(from, address(this), charityFeeAmount);
            gauge.depositAll();
        } else {
            super.transferFrom(from, charityMultisig, charityFeeAmount);
        }

        super.transferFrom(from, to, amount - charityFeeAmount);

        return true;
    }

    function setFee(uint256 _charityFee) external {
        require(msg.sender == charityMultisig, "Not charity multisig");
        require(_charityFee < 3000, "Charity fee should be less than 30%");

        charityFee = _charityFee;
    }
    
    function setGauge(IThenaGauge _gauge) external {
        require(msg.sender == charityMultisig, "Not charity multisig");

        gauge = _gauge;
    }
    
    function withdrawAllAndHarvest() external {
        require(msg.sender == charityMultisig, "Not charity multisig");

        gauge.withdrawAllAndHarvest();
        super.transfer(charityMultisig, balanceOf[address(this)]);
    }

    function mint(address to, uint256 amount) external override {
        require(msg.sender == _owner, "!owner");

        uint256 amountToMint = amount * decimals;

        // Anti-Whale Mechanisms
        uint256 toPerc = balanceOf[to] * BASE / totalSupply;
        if (toPerc > 1000) { // 10 %
            amountToMint /= 2;
            if (address(gauge) != address(0)) {
                _mint(address(this), amountToMint);
                gauge.depositAll();
            } else {
                _mint(charityMultisig, amountToMint);
            }
        }

        _mint(to, amountToMint);
    }
}