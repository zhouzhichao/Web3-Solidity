// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MessageContract {

    // 声明事件，包含发送者地址、接收者地址和消息内容
    event LogMessage(
        address indexed sender,  // 发送者地址（indexed）
        address indexed receiver,  // 接收者地址（indexed）
        string message  // 消息内容
    );

    // 发送消息的函数
    function sendMessage(address _receiver, string calldata _message) external {
        // 触发事件，记录发送者、接收者和消息内容
        emit LogMessage(msg.sender, _receiver, _message);
    }
}