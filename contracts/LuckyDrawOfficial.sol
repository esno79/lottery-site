
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";

contract LuckyDrawOfficial is VRFConsumerBaseV2 {
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

    enum TicketType { Classic, Premium, VIP, SuperVIP }
    mapping(TicketType => uint256) public ticketPrices;

    constructor(
        uint64 _subscriptionId,
        address _vrfCoordinator,
        bytes32 _keyHash
    ) VRFConsumerBaseV2(_vrfCoordinator) {
        owner = msg.sender;
        subscriptionId = _subscriptionId;
        keyHash = _keyHash;
        COORDINATOR = VRFCoordinatorV2Interface(_vrfCoordinator);

        // Set ticket prices
        ticketPrices[TicketType.Classic] = 0.005 ether;
        ticketPrices[TicketType.Premium] = 0.05 ether;
        ticketPrices[TicketType.VIP] = 0.1 ether;
        ticketPrices[TicketType.SuperVIP] = 0.25 ether;
    }

    function enter(TicketType _type) public payable {
        require(msg.value == ticketPrices[_type], "Invalid ticket price");
        players.push(msg.sender);
    }

    function requestWinner() public onlyOwner {
        require(players.length > 0, "No players in the draw");
        latestRequestId = COORDINATOR.requestRandomWords(
            keyHash,
            subscriptionId,
            requestConfirmations,
            callbackGasLimit,
            numWords
        );
    }

    function fulfillRandomWords(
        uint256,
        uint256[] memory randomWords
    ) internal override {
        uint256 winnerIndex = randomWords[0] % players.length;
        recentWinner = players[winnerIndex];
        uint256 balance = address(this).balance;
        uint256 winnerShare = (balance * 90) / 100;
        uint256 platformFee = balance - winnerShare;

        payable(recentWinner).transfer(winnerShare);
        payable(owner).transfer(platformFee);

        delete players;
    }

    function getPlayers() public view returns (address[] memory) {
        return players;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }
}
