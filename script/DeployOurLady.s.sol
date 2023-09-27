// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {OurLady} from "../src/OurLady.sol";

contract DeployOurLady is Script {
    uint256 public constant INITIAL_SUPPLY = 1_000_000_000_000;

    function run() external {
        vm.startBroadcast();
        new OurLady();
        vm.stopBroadcast();
     
    }
}