// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract AuctionFi {
    address public owner;
    uint public auctionEndTime;
    address public highestBidder;
    uint public highestBid;
    bool public ended;

    mapping(address => uint) public refunds;

    constructor() {
        owner = msg.sender;
        auctionEndTime = block.timestamp + 300; // Auction lasts 5 minutes
    }

    function bid() external payable {
        require(block.timestamp < auctionEndTime, "Auction ended");
        require(msg.value > highestBid, "Bid too low");

        if (highestBid != 0) {
            refunds[highestBidder] += highestBid;
        }

        highestBidder = msg.sender;
        highestBid = msg.value;
    }

    function withdrawRefund() external {
        uint amount = refunds[msg.sender];
        require(amount > 0, "No refund");

        refunds[msg.sender] = 0;
        payable(msg.sender).transfer(amount);
    }

    function endAuction() external {
        require(block.timestamp >= auctionEndTime, "Auction not over yet");
        require(!ended, "Already ended");

        ended = true;
        payable(owner).transfer(highestBid);
    }
}
