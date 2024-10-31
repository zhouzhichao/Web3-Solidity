// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MultiSigWallet {
    // 事件
    event Deposit(address indexed sender, uint256 amount);
    event Submit(uint256 indexed txIndex, address indexed owner, address indexed to, uint256 value, bytes data);
    event Approve(address indexed owner, uint256 indexed txIndex);
    event Execute(uint256 indexed txIndex, address indexed owner);
    event Revoke(address indexed owner, uint256 indexed txIndex);

    // 交易结构体
    struct Transaction {
        address to;           // 交易的目标地址
        uint256 value;        // 交易的以太币金额
        bytes data;           // 交易的附加数据
        bool executed;        // 交易是否已执行
        uint256 numApprovals; // 已批准的数量
    }

    // 状态变量
    address[] public owners;                // 所有者地址数组
    mapping(address => bool) public isOwner; // 用于快速检查某个地址是否为所有者
    uint256 public required;                // 执行交易所需的最少批准数

    Transaction[] public transactions;      // 交易数组
    mapping(uint256 => mapping(address => bool)) public approved; // 每个交易的每个所有者的批准状态

    // 修饰符：确保调用者是所有者
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

    // 修饰符：确保交易未被批准
    modifier notApproved(uint256 _txIndex) {
        require(!approved[_txIndex][msg.sender], "Transaction already approved");
        _;
    }

    // 构造函数：初始化所有者数组和执行交易所需的最少批准数
    constructor(address[] memory _owners, uint256 _required) {
        require(_owners.length > 0, "Owners required");
        require(_required > 0 && _required <= _owners.length, "Invalid required number of owners");

        for (uint256 i = 0; i < _owners.length; i++) {
            address owner = _owners[i];
            require(owner != address(0), "Invalid owner address");
            require(!isOwner[owner], "Owner not unique");

            isOwner[owner] = true;
            owners.push(owner);
        }

        required = _required;
    }

    // 接收以太币的函数
    receive() external payable {
        emit Deposit(msg.sender, msg.value);
    }

    // 提交新交易
    function submit(address _to, uint256 _value, bytes memory _data) public onlyOwner {
        transactions.push(Transaction({
            to: _to,
            value: _value,
            data: _data,
            executed: false,
            numApprovals: 0
        }));

        emit Submit(transactions.length - 1, msg.sender, _to, _value, _data);
    }

    // 批准交易
    function approve(uint256 _txIndex) public onlyOwner txExists(_txIndex) notExecuted(_txIndex) notApproved(_txIndex) {
        Transaction storage transaction = transactions[_txIndex];
        approved[_txIndex][msg.sender] = true;
        transaction.numApprovals += 1;

        emit Approve(msg.sender, _txIndex);
    }

    // 执行交易
    function execute(uint256 _txIndex) public onlyOwner txExists(_txIndex) notExecuted(_txIndex) {
        Transaction storage transaction = transactions[_txIndex];

        require(transaction.numApprovals >= required, "Cannot execute transaction");

        transaction.executed = true;

        (bool success, ) = transaction.to.call{value: transaction.value}(transaction.data);
        require(success, "Transaction failed");

        emit Execute(_txIndex, msg.sender);
    }

    // 撤销批准
    function revoke(uint256 _txIndex) public onlyOwner txExists(_txIndex) notExecuted(_txIndex) {
        require(approved[_txIndex][msg.sender], "Transaction not approved");

        Transaction storage transaction = transactions[_txIndex];
        approved[_txIndex][msg.sender] = false;
        transaction.numApprovals -= 1;

        emit Revoke(msg.sender, _txIndex);
    }

    // 获取所有者列表的函数（可选）
    function getOwners() public view returns (address[] memory) {
        return owners;
    }

    // 获取交易数量的函数（可选）
    function getTransactionCount() public view returns (uint256) {
        return transactions.length;
    }

    // 获取特定交易详情的函数（可选）
    function getTransaction(uint256 _txIndex) public view returns (address to, uint256 value, bytes memory data, bool executed, uint256 numApprovals) {
        Transaction storage transaction = transactions[_txIndex];
        return (transaction.to, transaction.value, transaction.data, transaction.executed, transaction.numApprovals);
    }
}