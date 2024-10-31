# Solidity 多签钱包 (Multi-Sig Wallet)

**多签钱包 (Multi-Signature Wallet)** 是一种需要多个用户（签名者）共同签署交易才能执行的智能合约。这种钱包非常适合增强资产的安全性，尤其是在需要多方共同管理资金的场景，比如 DAO、公司资金管理等。

下面，我们将实现一个标准的多签钱包合约，并为其编写测试用例。

### 多签钱包的主要功能

1. **添加签名者** ：钱包有一组预定义的签名者，只有这些签名者可以参与交易的审批。
2. **发起交易** ：任何签名者可以创建一个新的交易，比如转账资金。
3. **确认交易** ：签名者可以对交易进行确认。
4. **撤销确认** ：签名者可以撤销他们对某个交易的确认。
5. **执行交易** ：当足够多的签名者确认一笔交易后，交易可以被执行。
6. **查看交易信息** ：可以查看某个交易的详情，包括其确认状态、是否已执行等。

### 合约设计

我们将实现一个多签钱包，支持以下功能：

* **多签用户的管理** ：钱包在部署时指定签名者列表和执行交易所需的最少确认数。
* **交易管理** ：钱包允许发起新交易，并跟踪每个交易的状态，包括确认数和是否执行。
* **钱包功能** ：包括存款、发起交易、确认交易、撤销确认、执行交易等。

### Solidity 多签钱包合约实现

```Solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
contract MultiSigWallet {
    // 事件
    event Deposit(address indexed sender, uint256 amount);
    event SubmitTransaction(address indexed owner, uint256 indexed txIndex, address indexed to, uint256 value, bytes data);
    event ConfirmTransaction(address indexed owner, uint256 indexed txIndex);
    event RevokeConfirmation(address indexed owner, uint256 indexed txIndex);
    event ExecuteTransaction(address indexed owner, uint256 indexed txIndex);
    // 交易结构
    struct Transaction {
        address to;           // 交易的接收方
        uint256 value;        // 交易的金额
        bytes data;           // 交易的附加数据
        bool executed;        // 交易是否已执行
        uint256 numConfirmations;  // 已确认的数量
    }
    // 状态变量
    address[] public owners;     // 签名者地址列表
    mapping(address => bool) public isOwner;   // 地址是否为签名者
    uint256 public numConfirmationsRequired;   // 执行交易所需的最少确认数
    Transaction[] public transactions;   // 交易数组
    mapping(uint256 => mapping(address => bool)) public isConfirmed; // 交易确认状态
    // 修饰符：只允许钱包的所有者操作
    modifier onlyOwner() {
        require(isOwner[msg.sender], "Not an owner");
        _;
    }
    // 修饰符：确保交易存在
    modifier txExists(uint256 _txIndex) {
        require(_txIndex < transactions.length, "Transaction does not exist");
        _;
    }
    // 修饰符：确保交易未执行
    modifier notExecuted(uint256 _txIndex) {
        require(!transactions[_txIndex].executed, "Transaction already executed");
        _;
    }
    // 修饰符：确保交易未确认
    modifier notConfirmed(uint256 _txIndex) {
        require(!isConfirmed[_txIndex][msg.sender], "Transaction already confirmed");
        _;
    }
    // 构造函数：初始化签名者和确认数
    constructor(address[] memory _owners, uint256 _numConfirmationsRequired) {
        require(_owners.length > 0, "Owners required");
        require(_numConfirmationsRequired > 0 && _numConfirmationsRequired <= _owners.length, "Invalid confirmation number");
        for (uint256 i = 0; i < _owners.length; i++) {
            address owner = _owners[i];
            require(owner != address(0), "Invalid owner");
            require(!isOwner[owner], "Owner not unique");
            isOwner[owner] = true;
            owners.push(owner);
        }
        numConfirmationsRequired = _numConfirmationsRequired;
    }
    // 接收以太币
    receive() external payable {
        emit Deposit(msg.sender, msg.value);
    }
    // 提交交易
    function submitTransaction(address _to, uint256 _value, bytes memory _data) public onlyOwner {
        uint256 txIndex = transactions.length;
        transactions.push(Transaction({
            to: _to,
            value: _value,
            data: _data,
            executed: false,
            numConfirmations: 0
        }));
        emit SubmitTransaction(msg.sender, txIndex, _to, _value, _data);
    }
    // 确认交易
    function confirmTransaction(uint256 _txIndex) public onlyOwner txExists(_txIndex) notExecuted(_txIndex) notConfirmed(_txIndex) {
        Transaction storage transaction = transactions[_txIndex];
        transaction.numConfirmations += 1;
        isConfirmed[_txIndex][msg.sender] = true;
        emit ConfirmTransaction(msg.sender, _txIndex);
    }
    // 执行交易
    function executeTransaction(uint256 _txIndex) public onlyOwner txExists(_txIndex) notExecuted(_txIndex) {
        Transaction storage transaction = transactions[_txIndex];
        require(transaction.numConfirmations >= numConfirmationsRequired, "Cannot execute transaction");
        transaction.executed = true;
        (bool success, ) = transaction.to.call{value: transaction.value}(transaction.data);
        require(success, "Transaction failed");
        emit ExecuteTransaction(msg.sender, _txIndex);
    }
    // 撤销确认
    function revokeConfirmation(uint256 _txIndex) public onlyOwner txExists(_txIndex) notExecuted(_txIndex) {
        require(isConfirmed[_txIndex][msg.sender], "Transaction not confirmed");
        Transaction storage transaction = transactions[_txIndex];
        transaction.numConfirmations -= 1;
        isConfirmed[_txIndex][msg.sender] = false;
        emit RevokeConfirmation(msg.sender, _txIndex);
    }
    // 获取签名者数量
    function getOwners() public view returns (address[] memory) {
        return owners;
    }
    // 获取交易数量
    function getTransactionCount() public view returns (uint256) {
        return transactions.length;
    }
    // 获取交易详情
    function getTransaction(uint256 _txIndex) public view returns (
        address to,
        uint256 value,
        bytes memory data,
        bool executed,
        uint256 numConfirmations
    ) {
        Transaction storage transaction = transactions[_txIndex];
        return (
            transaction.to,
            transaction.value,
            transaction.data,
            transaction.executed,
            transaction.numConfirmations
        );
    }
}
```

### 合约功能说明

1. **签名者管理** ：
   1. `owners[]`: 存储所有签名者的地址。
   2. `isOwner`: 用来检查某个地址是否为签名者。
2. **交易管理** ：
   1. `Transaction`: 每个交易的结构，包含接收者地址、金额、数据、已确认的签名者数量和是否已执行。
   2. `transactions[]`: 存储所有交易。
   3. `isConfirmed`: 存储每个交易的每个签名者是否已确认。
3. **交易流程** ：
   1. **提交交易** ：签名者可以调用 `submitTransaction` 发起交易。
   2. **确认交易** ：签名者可以调用 `confirmTransaction` 确认交易。
   3. **执行交易** ：当确认数达到或超过阈值时，签名者可以调用 `executeTransaction` 执行交易。
   4. **撤销确认** ：如果交易尚未执行，签名者可以调用 `revokeConfirmation` 撤销对某个交易的确认。
4. **接收 Ether** ：合约可以接收以太币，储存在合约余额中。
5. 编写测试用例

我们将使用 Hardhat 编写测试用例，确保多签钱包的各项功能（如存款、提交交易、确认交易、执行交易等）正常。

#### 测试代码

```JavaScript
const { expect } = require("chai");
describe("MultiSigWallet", function () {
    let MultiSigWallet, wallet, owner, addr1, addr2, addr3, addr4;
    beforeEach(async function () {
        MultiSigWallet = await ethers.getContractFactory("MultiSigWallet");
        [owner, addr1, addr2, addr3, addr4] = await ethers.getSigners();
        // 部署合约，并设置 addr1, addr2, addr3 为签名者，最少需要 2 个确认
        wallet = await MultiSigWallet.deploy([addr1.address, addr2.address, addr3.address], 2);
        await wallet.deployed();
    });

    it("should allow deposits", async function () {
        // addr1 向合约转账
        await addr1.sendTransaction({ to: wallet.address, value: ethers.utils.parseEther("1.0") });
        // 检查合约余额
        const balance = await ethers.provider.getBalance(wallet.address);
        expect(balance).to.equal(ethers.utils.parseEther("1.0"));
    });

    it("should submit, confirm, and execute a transaction", async function () {
        // addr1 向合约转账
        await addr1.sendTransaction({ to: wallet.address, value: ethers.utils.parseEther("1.0") });
        // addr1 提交一个向 addr4 转账的交易
        await wallet.connect(addr1).submitTransaction(addr4.address, ethers.utils.parseEther("0.5"), "0x");
        // addr2 和 addr3 确认交易
        await wallet.connect(addr2).confirmTransaction(0);
        await wallet.connect(addr3).confirmTransaction(0);
        // 交易应当能够执行
        await wallet.connect(addr1).executeTransaction(0);
        // 检查 addr4 的余额
        const balance = await ethers.provider.getBalance(addr4.address);
        expect(balance).to.equal(ethers.utils.parseEther("10000.5")); // 初始余额为 10000 ETH
    });

    it("should fail to execute without enough confirmations", async function () {
        // addr1 向合约转账
        await addr1.sendTransaction({ to: wallet.address, value: ethers.utils.parseEther("1.0") });
        // addr1 提交一个向 addr4 转账的交易
        await wallet.connect(addr1).submitTransaction(addr4.address, ethers.utils.parseEther("0.5"), "0x");
        // addr2 确认交易，但未达到最少确认数
        await wallet.connect(addr2).confirmTransaction(0);
        // 尝试执行交易应当失败，因为确认数不足
        await expect(wallet.connect(addr1).executeTransaction(0)).to.be.revertedWith("Cannot execute transaction");
    });

    it("should allow revoking a confirmation", async function () {
        // addr1 向合约转账
        await addr1.sendTransaction({ to: wallet.address, value: ethers.utils.parseEther("1.0") });
        // addr1 提交一个向 addr4 转账的交易
        await wallet.connect(addr1).submitTransaction(addr4.address, ethers.utils.parseEther("0.5"), "0x");
        // addr2 和 addr3 确认交易
        await wallet.connect(addr2).confirmTransaction(0);
        await wallet.connect(addr3).confirmTransaction(0);
        // addr2 撤销确认
        await wallet.connect(addr2).revokeConfirmation(0);
        // 尝试执行交易应当失败，因为确认数不足
        await expect(wallet.connect(addr1).executeTransaction(0)).to.be.revertedWith("Cannot execute transaction");
    });
});
```

### 测试代码说明

1. **存款测试** ：验证钱包是否可以接收以太币存款。
2. **提交、确认和执行交易测试** ：测试签名者提交、确认并执行交易的完整流程。
3. **确认数不足时执行交易失败** ：验证当确认数不足时，交易无法执行。
4. **撤销确认** ：测试签名者撤销对某个交易的确认，并确保交易不能执行。

### 运行测试

确保你已安装 Hardhat，并运行以下命令来执行测试：

```Bash
npx hardhat test
```

### 总结

* 我们实现了一个典型的多签钱包功能，允许多个签名者共同管理资金。
* 合约支持基本的存款、提交交易、确认交易、撤销确认和执行交易功能。
* 我们通过测试用例验证了合约的核心功能，确保其在各种场景下的正确性。
