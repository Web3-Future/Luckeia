// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import {VRFConsumerBaseV2Plus} from "chainlink/src/v0.8/vrf/dev/VRFConsumerBaseV2Plus.sol";
import {VRFV2PlusClient} from "chainlink/src/v0.8/vrf/dev/libraries/VRFV2PlusClient.sol";

contract LuckyDraw is VRFConsumerBaseV2Plus {
    /**
     * ==================
     *  event
     * ==================
     */
    event LuckyDraw_RequestRandomWordsSent(uint256 indexed requestId, uint32 numWords, bool enableNativePayment);

    event LuckyDraw_RandomWordsFulfilled(uint256 indexed requestId, uint256[] randomWords);

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
    function enterRaffle() public payable {}

    // setUpLuckyDraw
    // pickWinner
    // prepare
    // claim

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

    function fulfillRandomWords(uint256 requestId, uint256[] memory randomWords) internal override {
        require(s_requests[requestId].exists, "requestId not found");
        s_requests[requestId].fulfilled = true;
        s_requests[requestId].randomWords = randomWords;

        emit LuckyDraw_RandomWordsFulfilled(requestId, randomWords);
    }
}
