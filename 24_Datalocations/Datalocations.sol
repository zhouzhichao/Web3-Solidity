// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract StructContract {

    // 定义一个结构体 MyStruct
    struct MyStruct {
        string text;        // 字符串成员
        uint[] numbers;     // 整数数组成员
    }

    // 定义一个状态变量来存储结构体
    MyStruct public myStruct;

    // 合约构造函数，初始化 struct 的成员
    constructor() {
        myStruct.text = "Initial text";
        myStruct.numbers = [1, 2, 3, 4, 5];  // 初始化整数数组
    }

    // 使用 storage 修改 struct 的字符串成员
    function updateText(string memory newText) public {
        // 使用 storage 来引用状态变量 myStruct
        MyStruct storage structRef = myStruct;
        structRef.text = newText;  // 修改结构体中的字符串成员
    }

    // 使用 calldata 读取 struct 的整数数组成员
    function readNumbers(uint[] calldata inputNumbers) public pure returns (uint) {
        uint sum = 0;

        // 遍历 calldata 数组并计算总和
        for (uint i = 0; i < inputNumbers.length; i++) {
            sum += inputNumbers[i];
        }

        return sum;  // 返回整数数组的总和
    }
}