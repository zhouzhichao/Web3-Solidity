# 英式拍卖 (English Auction)

**英式拍卖 (English Auction)** 是一种常见的拍卖形式。在这种类型的拍卖中，拍卖从一个较低的起始价格开始，潜在的买家不断进行出价，价格随着每次出价而上升。最终，出价最高的买家获胜，并以其出价购买物品。

### 英式拍卖的关键要素

1. **拍卖起始价格** ：拍卖从一个初始价格开始。
2. **最高出价者** ：拍卖过程中记录当前的最高出价者。
3. **最高出价** ：记录当前的最高出价。
4. **拍卖结束条件** ：
   * 拍卖在设定的时间结束（可以通过时间来控制）。
   * 或者，拍卖可以手动结束。
5. **出价流程** ：
   * 每个新的出价必须高于当前的最高出价。
   * 如果有人出价，那么之前的出价者可以取回他们的出价金额。
6. **拍卖结束时** ：
   * 最高出价者获得拍品。
   * 拍卖所得金额转给卖家。

### 英式拍卖的智能合约实现

我们将实现一个简单的英式拍卖合约，允许用户进行出价，并记录最高出价者和出价。

#### 合约设计

1. **状态变量** ：
   * `seller`：卖方，拍卖发起人。
   * `highestBid`：当前最高出价。
   * `highestBidder`：当前最高出价者。
   * `endAt`：拍卖结束时间。
   * `started`：标记拍卖是否已经开始。
   * `ended`：标记拍卖是否已经结束。
   * `bids`：一个映射，用于记录每个地址的出价金额，以便在出价未成功时可以退款。
2. **函数** ：
   * `start()`：开始拍卖，设置拍卖的持续时间。
   * `bid()`：用户可以通过该函数参与出价。
   * `end()`：结束拍卖，宣布获胜者。

### Solidity 英式拍卖智能合约

solidity

**复制**

```
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EnglishAuction {
    address public seller;       // 卖家地址
    uint256 public highestBid;   // 当前最高出价
    address public highestBidder; // 当前最高出价者
    uint256 public endAt;        // 拍卖结束时间
    bool public started;         // 拍卖是否开始
    bool public ended;           // 拍卖是否结束

    mapping(address => uint256) public bids; // 存储每个出价者的出价金额（用于退款）

    event AuctionStarted(uint256 startingBid, uint256 duration);
    event BidPlaced(address indexed bidder, uint256 amount);
    event AuctionEnded(address winner, uint256 amount);
    event BidWithdrawn(address indexed bidder, uint256 amount);

    modifier onlySeller() {
        require(msg.sender == seller, "Only seller can call this");
        _;
    }

    modifier auctionActive() {
        require(block.timestamp < endAt && started, "Auction is not active");
        _;
    }

    modifier auctionEnded() {
        require(block.timestamp >= endAt || ended, "Auction has not ended yet");
        _;
    }

    constructor() {
        seller = msg.sender;
    }

    // 开始拍卖，设置拍卖的起始出价和持续时间
    function start(uint256 _startingBid, uint256 _duration) external onlySeller {
        require(!started, "Auction already started");

        highestBid = _startingBid;
        endAt = block.timestamp + _duration;
        started = true;

        emit AuctionStarted(_startingBid, _duration);
    }

    // 出价函数
    function bid() external payable auctionActive {
        require(msg.value > highestBid, "Bid must be higher than current highest bid");

        // 如果当前存在一个最高出价者，需要将他们的出价金额存入 bids，以便可以退款
        if (highestBidder != address(0)) {
            bids[highestBidder] += highestBid; // 记录之前最高出价者的款项，用于退款
        }

        // 更新最高出价者和最高出价
        highestBid = msg.value;
        highestBidder = msg.sender;

        emit BidPlaced(msg.sender, msg.value);
    }

    // 允许未获胜的出价者取回他们的出价
    function withdraw() external {
        uint256 amount = bids[msg.sender];
        require(amount > 0, "No funds to withdraw");

        bids[msg.sender] = 0; // 防止重入攻击

        (bool success, ) = payable(msg.sender).call{value: amount}("");
        require(success, "Withdraw failed");

        emit BidWithdrawn(msg.sender, amount);
    }

    // 结束拍卖
    function end() external onlySeller auctionEnded {
        require(started, "Auction has not started");
        require(!ended, "Auction already ended");

        ended = true;

        // 将最高出价转给卖家
        if (highestBidder != address(0)) {
            (bool success, ) = payable(seller).call{value: highestBid}("");
            require(success, "Payment to seller failed");
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
```

### 合约功能解释

1. **状态变量** ：
   * `seller`：卖方，拍卖发起人。
   * `highestBid`：当前最高出价金额。
   * `highestBidder`：当前最高出价者。
   * `endAt`：拍卖的结束时间，通过 `start()` 函数设定。
   * `started`：表示拍卖是否已经开始。
   * `ended`：表示拍卖是否已经结束。
   * `bids`：映射存储每个出价者的出价金额，用于在出价未成功时退款。
2. **构造函数** ：
   * 设置拍卖的发起人为合约的部署者。
3. **`start()` 函数** ：
   * 卖家通过调用此函数开始拍卖，设置初始价格和拍卖持续时间。
   * 只能由卖家调用，并且只能调用一次。
4. **`bid()` 函数** ：
   * 允许参与者出价，出价金额必须高于当前最高出价。
   * 如果存在更高的出价者，之前的出价者的出价金额会被记录下来，以便他们可以通过 `withdraw()` 函数取回。
5. **`withdraw()` 函数** ：
   * 未获胜的出价者可以通过此函数取回他们的出价金额。
   * 合约中使用了 `reentrancy protection`，即在执行转账前将出价金额置为 0，以防止重入攻击。
6. **`end()` 函数** ：
   * 拍卖结束后，卖家可以调用此函数结束拍卖。
   * 拍卖结束后，最高出价者将支付的以太币转给卖家。
7. **`getRemainingTime()` 函数** ：
   * 返回拍卖结束前的剩余时间。

### 合同的工作流程

1. **开始拍卖** ：
   * 卖家调用 `start()` 函数指定拍卖开始时间、持续时间和起始价格。
2. **参与出价** ：
   * 任何人都可以调用 `bid()` 函数进行出价，出价必须高于当前最高出价。
   * 如果有新的最高出价者，之前的最高出价者可以在拍卖结束后取回他们的出价。
3. **拍卖结束** ：
   * 拍卖到达设定的结束时间后，卖家可以调用 `end()` 函数结束拍卖。
   * 合约会将最高出价者的出价转移给卖家，并宣布拍卖获胜者。
4. **出价退款** ：
   * 未获胜的出价者可以调用 `withdraw()` 函数取回他们的出价。

### 测试用例

可以使用 `Hardhat` 或 `Truffle` 来测试合约。以下是一个基于 `Hardhat` 的测试示例：

javascript

**复制**

```
const { expect } = require("chai");

describe("EnglishAuction", function () {
let auction, seller, bidder1, bidder2;

    beforeEach(asyncfunction () {
        [seller, bidder1, bidder2] = await ethers.getSigners();
const EnglishAuction = await ethers.getContractFactory("EnglishAuction", seller);
        auction = await EnglishAuction.deploy();
await auction.deployed();
    });

    it("should start auction", asyncfunction () {
const startingBid = ethers.utils.parseEther("1"); // 1 ETH
const duration = 300; // 300 seconds

await auction.start(startingBid, duration);

const highestBid = await auction.highestBid();
        expect(highestBid).to.equal(startingBid);
    });

    it("should accept higher bids", asyncfunction () {
const startingBid = ethers.utils.parseEther("1");
const duration = 300;

await auction.start(startingBid, duration);

await auction.connect(bidder1).bid({ value: ethers.utils.parseEther("2") });
        expect(await auction.highestBid()).to.equal(ethers.utils.parseEther("2"));
        expect(await auction.highestBidder()).to.equal(bidder1.address);

await auction.connect(bidder2).bid({ value: ethers.utils.parseEther("3") });
        expect(await auction.highestBid()).to.equal(ethers.utils.parseEther("3"));
        expect(await auction.highestBidder()).to.equal(bidder2.address);
    });

    it("should allow bidders to withdraw their bids", asyncfunction () {
const startingBid = ethers.utils.parseEther("1");
const duration = 300;

await auction.start(startingBid, duration);

await auction.connect(bidder1).bid({ value: ethers.utils.parseEther("2") });
await auction.connect(bidder2).bid({ value: ethers.utils.parseEther("3") });

const balanceBefore = await bidder1.getBalance();
const tx = await auction.connect(bidder1).withdraw();
const receipt = await tx.wait();
const gasUsed = receipt.gasUsed.mul(receipt.effectiveGasPrice);

const balanceAfter = await bidder1.getBalance();
        expect(balanceAfter.add(gasUsed)).to.equal(balanceBefore.add(ethers.utils.parseEther("2")));
    });

    it("should end auction and transfer funds to seller", asyncfunction () {
const startingBid = ethers.utils.parseEther("1");
const duration = 300;

await auction.start(startingBid, duration);
await auction.connect(bidder1).bid({ value: ethers.utils.parseEther("2") });

await ethers.provider.send("evm_increaseTime", [duration]);  // fast forward time
await ethers.provider.send("evm_mine");

const sellerBalanceBefore = await seller.getBalance();
const tx = await auction.end();
const receipt = await tx.wait();
const gasUsed = receipt.gasUsed.mul(receipt.effectiveGasPrice);

const sellerBalanceAfter = await seller.getBalance();
        expect(sellerBalanceAfter.add(gasUsed)).to.equal(sellerBalanceBefore.add(ethers.utils.parseEther("2")));
    });
});
```

### 测试说明

1. **开始拍卖** ：
   * 测试拍卖是否可以正常启动，并且设置的最高出价是否为拍卖的起始价格。
2. **接受更高的出价** ：
   * 测试合约是否可以接受更高的出价，并正确更新最高出价和最高出价者。
3. **出价退款** ：
   * 测试未获胜的出价者是否可以取回他们的出价。
4. **结束拍卖并转账给卖家** ：
   * 测试拍卖结束时，合约是否将最高出价的金额正确地转给卖家。

### 总结

* **英式拍卖 (English Auction)** 是一种价格随着出价不断上升的拍卖形式，拍卖结束时，最高出价者赢得拍品。
* 合约中实现了拍卖的开始、出价、退款和结束等基本功能。
* 通过测试可以验证合约是否正常工作，包括出价、退款和拍卖结束后的资金转移。
