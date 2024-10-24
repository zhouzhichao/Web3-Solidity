// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VisibilityExample {

    /// @dev 状态变量的可见性示例

    // public 状态变量：可以从外部和内部访问
    uint public publicValue = 100;

    // internal 状态变量：只能在当前合约和继承合约中访问
    uint internal internalValue = 200;

    // private 状态变量：只能在当前合约中访问
    uint private privateValue = 300;

    /// @dev 函数的可见性示例

    // public 函数：可以从外部和内部调用
    function getPublicValue() public view returns (uint) {
        return publicValue;
    }

    // internal 函数：只能在当前合约和继承合约中调用
    function getInternalValue() internal view returns (uint) {
        return internalValue;
    }

    // private 函数：只能在当前合约中调用
    function getPrivateValue() private view returns (uint) {
        return privateValue;
    }

    // external 函数：只能从外部调用，不能通过内部调用，除非使用 `this`
    function getExternalValue() external view returns (uint) {
        return publicValue + internalValue;
    }

    /// @dev 测试内部调用的函数
    function testInternalCalls() public view returns (uint, uint) {
        // 可以从内部调用 public 和 internal 函数
        uint internalVal = getInternalValue();
        uint publicVal = getPublicValue();

        // 无法直接调用 external 函数，必须通过 `this` 调用
        // uint externalVal = getExternalValue(); // 错误：external 函数不能内部调用
        uint externalVal = this.getExternalValue(); // 通过 `this` 调用 external 函数

        return (internalVal, externalVal);
    }

    /// @dev 测试私有函数的内部调用
    function testPrivateCall() public view returns (uint) {
        // 可以从内部调用 private 函数
        return getPrivateValue();
    }
}