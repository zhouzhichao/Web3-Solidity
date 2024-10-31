// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Caller {
    // 使用 call 调用 TestContract 的 foo() 函数
    function callFoo(address _testContract, string memory _msg, uint256 _num) public returns (bool, bytes memory) {
        // 构建函数签名和参数
        (bool success, bytes memory data) = _testContract.call(
            abi.encodeWithSignature("foo(string,uint256)", _msg, _num)
        );
        require(success, "Call to foo() failed");
        return (success, data);
    }

    // 使用 call 调用一个不存在的函数，触发回退函数
    function callNonExistentFunction(address _testContract) public returns (bool, bytes memory) {
        // 调用一个不存在的函数
        (bool success, bytes memory data) = _testContract.call(
            abi.encodeWithSignature("nonExistentFunction()")
        );
        // 检查是否成功
        require(!success, "The call should have failed, but it succeeded");
        return (success, data);
    }
}