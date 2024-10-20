// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MessageStore {

    // 公开的状态变量，用于存储字符串
    string public message;

    // 设置 message 的值，使用 calldata 作为参数的存储位置
    function setMessage(string calldata newMessage) external {
        message = newMessage;  // 将 calldata 参数赋值给 storage 变量
    }

    // 返回 message 的值，使用 memory 数据位置
    function getMessage() external view returns (string memory) {
        return message;  // 返回存储在 storage 中的字符串，自动转换为 memory
    }
}