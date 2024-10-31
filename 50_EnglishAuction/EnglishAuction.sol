// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract EnglishAuction is ReentrancyGuard {
    // 状态变量
    IERC721 public nft;            // NFT 合约地址
    uint256 public nftId;          // NFT 的 ID
    address public seller;         // 卖家地址
    uint256 public endAt;          // 拍卖结束时间
    bool public started;           // 拍卖是否开始
    bool public ended;             // 拍卖是否结束
    address public highestBidder;  // 当前最高出价者
    uint256 public highestBid;     // 当前最高出价金额
    mapping(address => uint256) public bids; // 存储出价者的出价金额（用于退款）

    // 事件
    event AuctionStarted(uint256 startingBid, uint256 duration);
    event BidPlaced(address indexed bidder, uint256 amount);
    event AuctionEnded(address winner, uint256 amount);
    event BidWithdrawn(address indexed bidder, uint256 amount);

    // 构造函数，初始化状态变量
    constructor(
        address _nft,       // NFT 合约地址
        uint256 _nftId,     // NFT ID
        uint256 _startingBid, // 起始出价金额
        uint256 _duration   // 拍卖持续时间 (秒)
    ) {
        nft = IERC721(_nft);
        nftId = _nftId;
        seller = msg.sender;  // 卖家为合约的部署者
        highestBid = _startingBid;
        
        endAt = block.timestamp + _duration;  // 拍卖结束时间

        emit AuctionStarted(_startingBid, _duration);
    }

    // 拍卖开始函数
    function start() external {
        require(!started, "Auction already started");
        require(msg.sender == seller, "Only seller can start the auction");

        started = true;

        // 将 NFT 所有权转移至合约
        nft.transferFrom(seller, address(this), nftId);

        emit AuctionStarted(highestBid, endAt - block.timestamp);
    }

    // 出价函数
    function bid() external payable {
        require(started, "Auction has not started");
        require(block.timestamp < endAt, "Auction has ended");
        require(msg.value > highestBid, "Bid must be higher than current highest bid");

        // 如果当前存在最高出价者，将他们的出价金额记录下来
        if (highestBidder != address(0)) {
            bids[highestBidder] += highestBid;
        }

        // 更新最高出价者和最高出价
        highestBid = msg.value;
        highestBidder = msg.sender;

        emit BidPlaced(msg.sender, msg.value);
    }

    // 提取资金函数，允许非最高出价者提取他们的出价
    function withdraw() external nonReentrant {
        uint256 amount = bids[msg.sender];
        require(amount > 0, "No funds to withdraw");

        bids[msg.sender] = 0;  // 防止重入攻击

        (bool success, ) = payable(msg.sender).call{value: amount}("");
        require(success, "Withdraw failed");

        emit BidWithdrawn(msg.sender, amount);
    }

    // 拍卖结束函数
    function end() external {
        require(started, "Auction has not started");
        require(block.timestamp >= endAt, "Auction has not ended yet");
        require(!ended, "Auction already ended");

        ended = true;

        if (highestBidder != address(0)) {
            // 将 NFT 转移给最高出价者
            nft.transferFrom(address(this), highestBidder, nftId);

            // 将最高出价金额转移给卖家
            (bool success, ) = payable(seller).call{value: highestBid}("");
            require(success, "Payment to seller failed");
        } else {
            // 如果没有出价，将 NFT 退回给卖家
            nft.transferFrom(address(this), seller, nftId);
        }

        emit AuctionEnded(highestBidder, highestBid);
    }

    // 获取拍卖剩余时间
    function getRemainingTime() public view returns (uint256) {
        if (block.timestamp >= endAt) {
            return 0;
        }
        return endAt - block.timestamp;
    }
}