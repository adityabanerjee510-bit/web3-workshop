# 🚀 AuctionFi - Transparent Bidding with Time-Bound Rules

Welcome to **AuctionFi**, a simple yet powerful smart contract built using **Solidity**.  
It enables **transparent, time-bound auctions** where bidders can compete fairly, and the process remains completely on-chain and verifiable.

---
<img width="1574" height="801" alt="image" src="https://github.com/user-attachments/assets/22152030-a674-49a0-b470-97ef8e99d490" />

## 🧠 Project Description

**AuctionFi** is a blockchain-based auction system designed for **transparency**, **fairness**, and **simplicity**.  
The smart contract allows users to bid using Ether, automatically handle refunds for losing bids, and ensure no further bids are accepted after the auction time ends.

It’s perfect for beginners who want to **learn how decentralized auctions work** on Ethereum!

---

## 💡 What It Does

- Deploy a simple auction that runs for a fixed amount of time.  
- Accept bids only if they are higher than the current highest bid.  
- Automatically refund previous highest bidders when they are outbid.  
- Allow bidders to withdraw their refunds safely.  
- Let the auction owner end the auction and receive the winning bid after time expires.  

---

## ✨ Features

- ⏰ **Time-Bound Auction:** Automatically closes after a set duration.  
- 💸 **Refund System:** Securely handles refunds for losing bidders.  
- 🔒 **Ownership Control:** Only the auction creator can finalize the auction.  
- 🔍 **Full Transparency:** Every bid and transaction is publicly visible on-chain.  
- 🧱 **Simple and Beginner-Friendly:** Easy to understand, modify, and deploy.  

---

## 🔗 Deployed Smart Contract

**Network:** Ethereum / Testnet (e.g., Sepolia or Mumbai)  
**Contract Address:** `https://celo-sepolia.blockscout.com/address/0xE9042f9a155E2D86939bB8edF5a87B7F4C54d4a6`

---

## 💻 Smart Contract Code

```solidity
//paste your code
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
