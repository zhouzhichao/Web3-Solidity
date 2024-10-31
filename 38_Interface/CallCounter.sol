// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ICounter.sol"; // 引入接口

contract CallCounter {
    uint public count; // 状态变量，存储从计数器合约获取的计数值
    address public counterAddress; // 计数器合约的地址

    // 设置目标计数器合约地址
    constructor(address _counterAddress) {
        counterAddress = _counterAddress;
    }

    // 调用接口的 increment 函数，增加计数
    function incrementCounter() public {
        ICounter(counterAddress).increment();
    }

    // 调用接口的 getCount 函数，并更新本地状态变量 count
    function updateCount() public {
        count = ICounter(counterAddress).getCount(); // 调用 getCount()
    }
}