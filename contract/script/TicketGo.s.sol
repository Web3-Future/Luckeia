// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import {Script, console} from "forge-std/Script.sol";
import {TicketGoNFT} from "../src/TicketGo/NFT.sol";
import {TicketGo} from "../src/TicketGo/TicketGoPure.sol";

contract TicketGoScript is Script {
    function setUp() public {}

    function run() public returns (address) {
        vm.startBroadcast();
        // Sepolia TestNet
        address nftAddr = address(new TicketGoNFT());
        address ticketGoAddr = address(new TicketGo(nftAddr));
        vm.stopBroadcast();
        return ticketGoAddr;
    }
}
