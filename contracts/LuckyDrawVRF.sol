// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";
import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";

contract LuckyDrawVRF is VRFConsumerBaseV2 {
    address public owner;
    address[] public players;
    address public recentWinner;

    VRFCoordinatorV2Interface COORDINATOR;

    uint64 public subscriptionId;
    bytes32 public keyHash;
    uint32 public callbackGasLimit = 100000;
    uint16 public requestConfirmations = 3;
    uint32 public numWords = 1;

    uint256 public latestRequestId;

    constructor(
        uint64 _subId,
        address _vrfCoordinator,
        bytes32 _keyHash
    ) VRFConsumerBaseV2(_vrfCoordinator) {
        owner = msg.sender;
        subscriptionId = _subId;
        keyHash = _keyHash;
        COORDINATOR = VRFCoordinatorV2Interface(_vrfCoordinator);
    }

    function enter() public {
        players.push(msg.sender);
    }

    function requestWinner() public onlyOwner {
        latestRequestId = COORDINATOR.requestRandomWords(
            keyHash,
            subscriptionId,
            requestConfirmations,
            callbackGasLimit,
            numWords
        );
    }

    function fulfillRandomWords(
        uint256, /* requestId */
        uint256[] memory randomWords
    ) internal override {
        uint256 index = randomWords[0] % players.length;
        recentWinner = players[index];
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner");
        _;
    }

    function getPlayers() public view returns (address[] memory) {
        return players;
    }
}
