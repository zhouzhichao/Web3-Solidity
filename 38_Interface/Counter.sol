// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Counter {
    uint public count; // 状态变量，自动生成 getter 函数

    // 重命名函数，避免与状态变量同名
    function getCount() external view returns (uint) {
        return count;
    }

    // 增加计数
    function increment() external {
        count += 1;
    }
}