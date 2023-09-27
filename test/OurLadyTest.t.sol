 // SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {DeployOurLady} from "../script/DeployOurLady.s.sol";
import {OurLady} from "../src/OurLady.sol";
import {Test, console} from "forge-std/Test.sol";
import {StdCheats} from "forge-std/StdCheats.sol";

interface MintableToken {
    function mint(address, uint256) external;
}

contract OurLadyTest is StdCheats, Test {
    uint256 BOB_STARTING_AMOUNT = 100 ether;

    OurLady public ourLady;
    DeployOurLady public deployer;
    address public deployerAddress;
    address bob;
    address alice;

    function setUp() public {
        deployer = new DeployOurLady();
        deployerAddress = address(deployer);

        bob = makeAddr("bob");
        alice = makeAddr("alice");

      
        vm.prank(deployerAddress);
        ourLady.transfer(bob, BOB_STARTING_AMOUNT);
    }

    function testInitialSupply() public {
        assertEq(ourLady.totalSupply(), deployer.INITIAL_SUPPLY());
    }

    function testUsersCantMint() public {
        vm.expectRevert();
        MintableToken(address(ourLady)).mint(address(this), 1);
    }

    function testAllowances() public {
        uint256 initialAllowance = 1000;

        // Bob approves Alice to spend tokens on her behalf
        vm.prank(bob);
        ourLady.approve(alice, initialAllowance);
        uint256 transferAmount = 500;

        vm.prank(alice);
        ourLady.transferFrom(bob, alice, transferAmount);
        assertEq(ourLady.balanceOf(alice), transferAmount);
        assertEq(ourLady.balanceOf(bob), BOB_STARTING_AMOUNT - transferAmount);
    }


}