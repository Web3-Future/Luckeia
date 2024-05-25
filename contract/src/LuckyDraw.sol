// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import {VRFConsumerBaseV2Plus} from "@chainlink/contracts/src/v0.8/vrf/dev/VRFConsumerBaseV2Plus.sol";
import {VRFV2PlusClient} from "@chainlink/contracts/src/v0.8/vrf/dev/libraries/VRFV2PlusClient.sol";
import {Address} from "@openzeppelin/contracts/utils/Address.sol";

contract LuckyDraw is VRFConsumerBaseV2Plus {
    /**
     * ==================
     *  error
     * ==================
     */
    error LuckyDraw_SetUpLuckyDrawStrategyCustomFaild();
    error LuckyDraw_OpenAwardsLuckyDrawStrategyCustomFailed();

    /**
     * ==================
     *  event
     * ==================
     */
    event LuckyDraw_RequestRandomWordsSent(uint256 indexed requestId, uint32 numWords, bool enableNativePayment);

    event LuckyDraw_StrategyCustomSetUp(uint256 indexed luckyDrawNumber, bytes data);

    event LuckyDraw_RandomWordsFulfilled(uint256 indexed requestId, uint256[] randomWords);

    event LuckyDraw_StrategyASetUp(
        uint256 indexed luckyDrawNumber,
        uint256 startTime,
        uint256 endTime,
        address payable[] participants,
        uint8 maxWinners,
        address[] openerWhitelist
    );

    event LuckyDraw_StrategyACancled(address indexed user, uint256 luckyDrawNumber);

    event LuckyDraw_lucyNumberPicked(address indexed user, uint256 luckNumber);

    /**
     * ==================
     *  struct
     * ==================
     */
    struct RequestStatus {
        bool exists; // whether a requestId exists
        bool fulfilled; // whether the request has been successfully fulfilled
        uint256[] randomWords;
    }

    // struct StrategyBaseRulesInfo {
    //     address admin;
    //     bool isOpen; // whether the lucky draw is open
    // }

    struct StrategyARulesInfo {
        address admin;
        bool isOpen; // whether the lucky draw is open
        uint256 startTime;
        uint256 endTime;
        uint256 amount;
        address payable[] participants;
        uint8 maxWinners;
        address[] openerWhitelist;
    }

    struct StrategyBRulesInfo {
        address admin;
        bool isOpen; // whether the lucky draw is open
        uint256 startTime;
        uint256 endTime;
        uint256 rechargeAmount;
        uint8 maxWinners;
    }

    struct StrategyCustomRulesInfo {
        address admin;
        bool isOpen; // whether the lucky draw is open
        uint256 amount;
        bytes data; // custom calldata
    }

    /**
     * ==================
     *  storage & constants
     * ==================
     */
    // The default is 3
    uint16 public constant REQUEST_CONFIRMATIONS = 3;

    // Depends on the number of requested values that you want sent to the
    // fulfillRandomWords() function. Storing each word costs about 20,000 gas,
    // so 100,000 is a safe default for this example contract.
    uint32 public constant CALLBACK_GAS_LIMIT = 100000;

    // For this example, retrieve 2 random values in one request.
    uint32 public constant NUM_WORDS = 2;

    // subscription ID
    uint256 private s_subscriptionId;

    // The gas lane to use, which specifies the maximum gas price to bump to.
    // For a list of available gas lanes on each network,
    // see https://docs.chain.link/vrf/v2-5/supported-networks
    bytes32 private s_keyHash = 0x787d74caea10b2b357790d5b5247c2f63d1d91572a9846f780606e4d953677ae;

    mapping(uint256 => RequestStatus) private s_requests;

    // LuckyDraw unique number,will always increase
    uint256 private s_numberOfLuckyDraw;

    // key=luckyDrawNumber,value=StrategyARulesInfo
    mapping(uint256 => StrategyARulesInfo) private s_strategyARulesInfos;

    mapping(uint256 => StrategyBRulesInfo) private s_strategyBRulesInfos;

    mapping(uint256 => StrategyCustomRulesInfo) private s_strategyCustomRulesInfos;

    // key=luckyDrawNumber,value=winners
    mapping(uint256 => mapping(address => bool)) private s_winners;

    /**
     * ==================
     *  constructor
     * ==================
     */

    /**
     * Sepolia TestNet
     * VRF Coordinator: 0x9DdfaCa8183c41ad55329BdeeD9F6A8d53168B1B
     */
    constructor(uint256 subscriptionId_, address _vrfCoordinator, bytes32 keyHash_)
        VRFConsumerBaseV2Plus(_vrfCoordinator)
    {
        s_subscriptionId = subscriptionId_;
        s_keyHash = keyHash_;
    }

    /**
     * ==================
     *  function public & external
     * ==================
     */
    function setUpLuckyDrawStrategyA(
        uint256 startTime,
        uint256 endTime,
        address payable[] calldata participants,
        uint8 maxWinners,
        address[] calldata openerWhitelist
    ) external payable returns (uint256) {
        require(startTime > block.timestamp, "startTime must be in the future");
        require(startTime < endTime, "endTime must be after startTime");
        require(maxWinners > 0, "maxWinners must be greater than 0");
        require(participants.length >= maxWinners, "participants must be greater than or equal to maxWinners");
        require(openerWhitelist.length > 0, "openerWhitelist must be greater than 0");
        uint256 amount = msg.value;
        require(amount > 0, "amount must be greater than 0");

        // record
        s_numberOfLuckyDraw += s_numberOfLuckyDraw;

        s_strategyARulesInfos[s_numberOfLuckyDraw] = StrategyARulesInfo({
            startTime: startTime,
            endTime: endTime,
            amount: amount,
            participants: participants,
            maxWinners: maxWinners,
            openerWhitelist: openerWhitelist,
            isOpen: true,
            admin: msg.sender
        });

        emit LuckyDraw_StrategyASetUp(
            s_numberOfLuckyDraw, startTime, endTime, participants, maxWinners, openerWhitelist
        );

        return s_numberOfLuckyDraw;
    }

    function openAwardsLuckyDrawStrategyA(uint256 luckyDrawNumber) external {
        StrategyARulesInfo memory luckyDrawRulesInfo = s_strategyARulesInfos[luckyDrawNumber];
        require(luckyDrawRulesInfo.isOpen, "luckyDraw is alread closed");
        require(luckyDrawRulesInfo.endTime < block.timestamp, "luckyDraw is not ended");
        require(_checkInWhitelist(msg.sender, luckyDrawRulesInfo.openerWhitelist), "only opener can open");

        uint256 requestId = requestRandomWords(true);
        uint8 maxWinners = luckyDrawRulesInfo.maxWinners;
        // caculate per user rewards
        uint256 rewardsPerUser = luckyDrawRulesInfo.amount / maxWinners;
        uint256[] memory randomWords = s_requests[requestId].randomWords;
        uint256 firstIndexOfWinner = randomWords[0] % luckyDrawRulesInfo.participants.length;
        for (uint256 i = 0; i < maxWinners; i++) {
            address payable winner = luckyDrawRulesInfo.participants[firstIndexOfWinner];
            s_winners[luckyDrawNumber][address(winner)] = true;
            firstIndexOfWinner += 1;
            Address.sendValue(winner, rewardsPerUser);
        }
    }

    function _checkInWhitelist(address user, address[] memory whitelist) internal pure returns (bool) {
        for (uint256 i = 0; i < whitelist.length; i++) {
            if (whitelist[i] == user) {
                return true;
            }
        }
        return false;
    }

    function cancelLuckyDrawStrategyA(uint256 luckyDrawNumber) external {
        _cancelLuckyDrawStrategyCustom(luckyDrawNumber);
    }

    function _cancelLuckyDrawStrategyCustom(uint256 luckyDrawNumber) internal {
        address user = msg.sender;
        require(s_strategyARulesInfos[luckyDrawNumber].admin == user, "only admin can cancel");
        require(s_strategyARulesInfos[luckyDrawNumber].isOpen, "luckyDraw is alread closed");

        s_strategyARulesInfos[luckyDrawNumber].isOpen = false;

        emit LuckyDraw_StrategyACancled(user, luckyDrawNumber);
    }

    function checkUserPrizeLuckyDrawStrategyA(uint256 luckyDrawNumber, address user) public view returns (bool) {
        require(s_strategyARulesInfos[luckyDrawNumber].isOpen, "luckyDraw is closed");
        require(s_strategyARulesInfos[luckyDrawNumber].startTime < block.timestamp, "luckyDraw is not started");

        // check user exist
        return s_winners[luckyDrawNumber][user];
    }

   
    /**
     * ================== StrategyC ==================
     */
    function pickLuckNumberStrategyC(uint256 start, uint256 end) external returns (uint256) {
        require(start > 0, "start number must gt 0");
        require(start < end, "start number must less than end number");

        uint256 requestId = requestRandomWords(true);
        uint256[] memory randomWords = s_requests[requestId].randomWords;
        uint256 luckNumber = randomWords[0] % (end - start) + start;

        emit LuckyDraw_lucyNumberPicked(msg.sender, luckNumber);
        return luckNumber;
    }

    /**
     * ================== StrategyD-custom ==================
     */
    function setUpLuckyDrawStrategyCustom(address customStrategyAddress, bytes calldata data)
        external
        payable
        returns (uint256)
    {
        uint256 amount = msg.value;
        require(amount > 0, "amount must be greater than 0");

        // record
        s_numberOfLuckyDraw += s_numberOfLuckyDraw;

        s_strategyCustomRulesInfos[s_numberOfLuckyDraw] =
            StrategyCustomRulesInfo({amount: amount, isOpen: true, admin: msg.sender, data: data});

        (bool success,) = customStrategyAddress.delegatecall(data);
        if (!success) {
            revert LuckyDraw_SetUpLuckyDrawStrategyCustomFaild();
        }

        emit LuckyDraw_StrategyCustomSetUp(s_numberOfLuckyDraw, data);

        return s_numberOfLuckyDraw;
    }

    function openAwardsLuckyDrawStrategyCustom(
        address customStrategyAddress,
        uint256 luckyDrawNumber,
        bytes calldata data
    ) external {
        require(s_strategyCustomRulesInfos[luckyDrawNumber].isOpen, "luckyDraw is alread closed");

        (bool success,) = customStrategyAddress.delegatecall(data);
        if (!success) {
            revert LuckyDraw_OpenAwardsLuckyDrawStrategyCustomFailed();
        }
    }

    function cancelLuckyDrawStrategyCustom(uint256 luckyDrawNumber) external {
        address user = msg.sender;
        require(s_strategyCustomRulesInfos[luckyDrawNumber].admin == user, "only admin can cancel");
        require(s_strategyCustomRulesInfos[luckyDrawNumber].isOpen, "luckyDraw is alread closed");

        s_strategyCustomRulesInfos[luckyDrawNumber].isOpen = false;

        emit LuckyDraw_StrategyACancled(user, luckyDrawNumber);
    }

    /**
     * ==================
     *  function internale & private
     * ==================
     */

    // requestRandomWords
    // @param enableNativePayment: Set to `true` to enable payment in native tokens, or`false` to pay in LINK
    function requestRandomWords(bool enableNativePayment) internal returns (uint256) {
        uint256 requestId = s_vrfCoordinator.requestRandomWords(
            VRFV2PlusClient.RandomWordsRequest({
                keyHash: s_keyHash,
                subId: s_subscriptionId,
                requestConfirmations: REQUEST_CONFIRMATIONS,
                callbackGasLimit: CALLBACK_GAS_LIMIT,
                numWords: NUM_WORDS,
                extraArgs: VRFV2PlusClient._argsToBytes(VRFV2PlusClient.ExtraArgsV1({nativePayment: enableNativePayment}))
            })
        );
        s_requests[requestId] = RequestStatus({exists: true, fulfilled: false, randomWords: new uint256[](0)});

        emit LuckyDraw_RequestRandomWordsSent(requestId, NUM_WORDS, enableNativePayment);
        return requestId;
    }

    function fulfillRandomWords(uint256 requestId, uint256[] calldata randomWords) internal override {
        require(s_requests[requestId].exists, "requestId not found");
        s_requests[requestId].fulfilled = true;
        s_requests[requestId].randomWords = randomWords;

        emit LuckyDraw_RandomWordsFulfilled(requestId, randomWords);
    }
}
