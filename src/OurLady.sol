// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ERC20} from "../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract OurLady is ERC20 {
    uint256 maxHolding = totalSupply() / 100; // 1% of total supply
    address deployer = msg.sender;

    constructor() ERC20("OurLady", "OLADY") {
        _mint(msg.sender, 1_000_000_000_000 * (10 ** decimals()));
        maxHolding = totalSupply() / 100; // 1% of total supply
    }

    function transfer(
        address recipient,
        uint256 amount
    ) public override returns (bool) {
        if (msg.sender != deployer) {
            require(
                balanceOf(recipient) + amount <= maxHolding,
                "Exceeds max holding limit"
            );
        }
        return super.transfer(recipient, amount);
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public override returns (bool) {
        if (sender != deployer) {
            require(
                balanceOf(recipient) + amount <= maxHolding,
                "Exceeds max holding limit"
            );
        }
        return super.transferFrom(sender, recipient, amount);
    }

    uint256 public buySellTax = 2; // 2%
    address public rewardPool;

    function _applyTax(
        address sender,
        uint256 amount
    ) internal returns (uint256) {
        uint256 taxAmount = (amount * buySellTax) / 100;
        uint256 rewardAmount = (taxAmount * 90) / 100;
        uint256 deployerAmount = taxAmount - rewardAmount;

        _transfer(sender, rewardPool, rewardAmount);
        _transfer(sender, deployer, deployerAmount);

        return amount - taxAmount;
    }

    address[] public eligibleAddresses;

    function burnForEligibility(uint256 amount) public {
        _burn(msg.sender, amount);
        eligibleAddresses.push(msg.sender);
    }
}
