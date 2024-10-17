// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MultiReturnExample {

    // 状态变量，用于存储从 returnMultiple() 捕获的值
    uint public storedNumber;
    bool public storedBool;
    string public storedString;

    // 函数：返回三个不同类型的值
    function returnMultiple() public pure returns (uint, bool, string memory) {
        return (42, true, "Hello, Solidity!");
    }

    // 函数：使用解构赋值捕获 returnMultiple() 的返回值，并存储在状态变量中
    function captureOutputs() public {
        (storedNumber, storedBool, storedString) = returnMultiple();
    }

    // 函数：返回存储在状态变量中的值
    function displayOutputs() public view returns (uint, bool, string memory) {
        return (storedNumber, storedBool, storedString);
    }
}