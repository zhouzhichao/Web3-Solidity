// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract Calculator {
    function multiply(uint x, uint y) external pure returns (uint) { 
        // 使用 external 修饰符，意味着这个函数只能从合约外部调用。
        //使用 pure 修饰符，因为该函数不读取也不修改合约的状态。
        return x * y;
    }

    function divide(uint a, uint b) external pure returns (uint) {
        require(b != 0, "Division by zero is not allowed");
        return a / b;
    }
}