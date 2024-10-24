// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EtherReceiver {

    // 收款地址，payable 类型
    address payable public recipient;

    // 定义事件，用于记录错误日志
    event LogFallbackCalled(address sender, uint amount, string message);
    event LogReceiveCalled(address sender, uint amount);

    // 构造函数，初始化 recipient 为部署合约的地址
    constructor() {
        recipient = payable(msg.sender);
    }

    // payable 函数，用于接收以太币
    function receiveEther() public payable {
        // 接收的以太币会自动记录在合约的余额中
        require(msg.value > 0, "Must send some Ether");
    }

    // 返回合约的余额
    function queryBalance() public view returns (uint) {
        return address(this).balance;
    }

    // receive 函数，专门用于接收以太币
    receive() external payable {
        emit LogReceiveCalled(msg.sender, msg.value);
        // 任何发送到合约的以太币将被接收
    }

    // 当未使用 payable 时调用 fallback 函数，记录错误日志
    fallback() external payable {
        // 记录日志并返回错误信息
        emit LogFallbackCalled(msg.sender, msg.value, "Fallback called: Non-payable function or wrong call");
        // 注意：如果不想接收以太币，可以使用 `revert()` 来拒绝
        revert("This contract cannot receive Ether this way!");
    }
}