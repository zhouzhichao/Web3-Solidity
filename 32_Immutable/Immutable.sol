// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract OwnerContract {

    // 使用 immutable 关键字定义 owner 状态变量
    address public immutable owner;

    // 构造函数，用于初始化 owner 变量为 msg.sender
    constructor() {
        owner = msg.sender;
    }

    // 返回 owner 的值
    function getOwner() public view returns (address) {
        return owner;
    }
}