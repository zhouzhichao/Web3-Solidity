// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract SimpleStorage {
    uint public storedData; // 如果状态变量的可见性设置为 public，Solidity 会自动为该变量生成一个 getter 函数，允许外部合约或外部调用者访问它的值。
    function set(uint x) public {
        storedData = x;
    }
    function get() public view returns (uint) {
        return storedData;
    }
}