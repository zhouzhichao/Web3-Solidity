// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract FallbackAndReceive {

    // 定义事件，用于记录调用日志
    event LogFallbackCalled(address sender, uint amount, bytes data);
    event LogReceiveCalled(address sender, uint amount);

    // receive 函数：用于接收没有附带数据的以太币
    receive() external payable {
        emit LogReceiveCalled(msg.sender, msg.value);
    }

    // fallback 函数：用于接收带有数据的以太币或调用不存在的函数
    fallback() external payable {
        emit LogFallbackCalled(msg.sender, msg.value, msg.data);
    }

    // 返回合约的余额
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}