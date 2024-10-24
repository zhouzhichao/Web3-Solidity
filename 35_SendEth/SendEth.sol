// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ETHManager {

    // 定义事件，用于记录发送的交易结果
    event TransferSent(address indexed recipient, uint amount);
    event SendStatus(address indexed recipient, bool success, uint amount);
    event CallStatus(address indexed recipient, bool success, uint amount);

    // receive 函数，用于接收 ETH
    receive() external payable {}

    // 获取合约的当前余额
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }

    // 使用 transfer 方法发送 ETH
    function sendViaTransfer(address payable recipient, uint amount) public {
        require(address(this).balance >= amount, "Insufficient balance");
        recipient.transfer(amount);  // 使用 transfer 发送 ETH
        emit TransferSent(recipient, amount);
    }

    // 使用 send 方法发送 ETH，并处理失败的情况
    function sendViaSend(address payable recipient, uint amount) public {
        require(address(this).balance >= amount, "Insufficient balance");
        bool success = recipient.send(amount);  // 使用 send 发送 ETH
        emit SendStatus(recipient, success, amount);
        require(success, "Send failed");
    }

    // 使用 call 方法发送 ETH，并处理返回值
    function sendViaCall(address payable recipient, uint amount) public {
        require(address(this).balance >= amount, "Insufficient balance");
        (bool success, ) = recipient.call{value: amount}("");  // 使用 call 发送 ETH
        emit CallStatus(recipient, success, amount);
        require(success, "Call failed");
    }
}