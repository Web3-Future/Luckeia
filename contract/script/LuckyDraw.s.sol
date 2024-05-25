// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import {Script, console} from "forge-std/Script.sol";
import {LuckyDraw} from "../src/LuckyDraw.sol";

// cd contract
// forge script --rpc-url http://127.0.0.1:8545 ./script/LuckyDraw.s.sol --broadcast
contract LuckyDrawScript is Script {
    function setUp() public {}

    function run() public returns (address) {
        vm.startBroadcast();
        // Sepolia TestNet
        uint256 subscriptionId = 41708014713677972126272041568170525188597109364547928923715746646665631094557;
        address vrfCoordinator = 0x9DdfaCa8183c41ad55329BdeeD9F6A8d53168B1B;
        bytes32 keyHash = 0x787d74caea10b2b357790d5b5247c2f63d1d91572a9846f780606e4d953677ae;
        address luckyDraw = address(new LuckyDraw(subscriptionId, vrfCoordinator, keyHash));
        vm.stopBroadcast();
        return luckyDraw;
    }
}
