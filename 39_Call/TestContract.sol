/**
1. 创建一个名为`TestContract`的合约，包含以下函数：
- `foo(string memory _msg, uint256 _num)`: 接受字符串和uint256类型参数，并更新状态变量`message`和`number`。
- `fallback() external`: 回退函数，记录日志"Fallback was called"。
2. 创建一个名为`Caller`的合约，包含以下函数：
- `callFoo(address _testContract, string memory _msg, uint256 _num)`: 使用call调用`TestContract`合约中的`foo`函数，并传递参数。
- `callNonExistentFunction(address _testContract)`: 使用call调用一个不存在的函数，验证回退函数是否被调用。

**/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TestContract {
    string public message;
    uint256 public number;

    // 更新状态变量 message 和 number
    function foo(string memory _msg, uint256 _num) public {
        message = _msg;
        number = _num;
    }

    // 回退函数，记录日志
    fallback() external {
        emit Log("Fallback was called");
    }

    // 定义事件，用于记录日志
    event Log(string message);
}