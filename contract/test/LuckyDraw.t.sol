// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {LuckyDraw} from "../src/LuckyDraw.sol";

contract LuckyDrawTest is Test {
    LuckyDraw public luckyDraw;

    address player1 = makeAddr("player1");
    address player2 = makeAddr("player2");
    address player3 = makeAddr("player3");
    address player4 = makeAddr("player4");
    address player5 = makeAddr("player5");

    address opener1 = makeAddr("opener1");
    address opener2 = makeAddr("opener2");
    address opener3 = makeAddr("opener3");

    address admin = makeAddr("admin");

    function setUp() public {
        // Sepolia TestNet
        uint256 subscriptionId = 41708014713677972126272041568170525188597109364547928923715746646665631094557;
        address vrfCoordinator = 0x9DdfaCa8183c41ad55329BdeeD9F6A8d53168B1B;
        bytes32 keyHash = 0x787d74caea10b2b357790d5b5247c2f63d1d91572a9846f780606e4d953677ae;
        luckyDraw = new LuckyDraw(subscriptionId, vrfCoordinator, keyHash);

        vm.deal(admin, 100 ether);
    }

    function test_Increment() public {}

    // test setUpLuckyDrawStrategyA
    function test_setUpLuckyDrawStrategyA() public {
        uint256 numberOfLuckyDraw = _setUpLuckyDrawStrategyA();
        assertEq(1, numberOfLuckyDraw);
    }

    function _setUpLuckyDrawStrategyA() internal returns (uint256) {
        vm.startPrank(admin);
        uint256 startTime = block.timestamp + 1 days;
        uint256 endTime = block.timestamp + 3 days;
        address payable[] memory participants = new address payable[](5);
        participants[0] = payable(player1);
        participants[1] = payable(player2);
        participants[2] = payable(player3);
        participants[3] = payable(player4);
        participants[4] = payable(player5);
        uint8 maxWinners = 3;
        address[] memory openerWhitelist = new address[](3);
        openerWhitelist[0] = opener1;
        openerWhitelist[1] = opener2;
        openerWhitelist[2] = opener3;
        uint256 numberOfLuckyDraw = luckyDraw.setUpLuckyDrawStrategyA{value: 10 ether}(
            startTime, endTime, participants, maxWinners, openerWhitelist
        );
        vm.stopPrank();
        return numberOfLuckyDraw;
    }

    function test_cancelLuckyDrawStrategyA() public {
        uint256 numberOfLuckyDraw = _setUpLuckyDrawStrategyA();
        vm.startPrank(admin);
        luckyDraw.cancelLuckyDrawStrategyA(numberOfLuckyDraw);
        LuckyDraw.StrategyARulesInfo memory info = luckyDraw.getStrategyARulesInfo(numberOfLuckyDraw);
        assertEq(false, info.isOpen);
        vm.stopPrank();
    }

    // test checkUserPrizeLuckyDrawStrategyA
    function test_checkUserPrizeLuckyDrawStrategyA() public {
        uint256 numberOfLuckyDraw = _setUpLuckyDrawStrategyA();
        vm.warp(block.timestamp + 4 days);
        vm.startPrank(player1);
        bool isWin = luckyDraw.checkUserPrizeLuckyDrawStrategyA(numberOfLuckyDraw);
        assertEq(false, isWin);
        vm.stopPrank();
    }

    // test openAwardsLuckyDrawStrategyA
    function test_openAwardsLuckyDrawStrategyA() public {
        uint256 numberOfLuckyDraw = _setUpLuckyDrawStrategyA();
        vm.warp(block.timestamp + 4 days);
        
        vm.startPrank(opener1);
        luckyDraw.openAwardsLuckyDrawStrategyA(numberOfLuckyDraw);
        // LuckyDraw.StrategyARulesInfo memory info = luckyDraw.getStrategyARulesInfo(numberOfLuckyDraw);
        // assertEq(true, info.isOpen);
        vm.stopPrank();
    }
}
