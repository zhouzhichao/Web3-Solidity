// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// 合约 A，定义 functionA
contract A {
    function functionA() public virtual pure returns (string memory) {
        return "Function A from Contract A";
    }
}

// 合约 B 继承自 A，并重写 functionA
contract B is A {
    function functionA() public virtual override pure returns (string memory) {
        return "Function A from Contract B";
    }
}

// 合约 C 继承自 B 和 A，并重写 functionA
contract C is B {
    function functionA() public override pure returns (string memory) {
        return "Function A from Contract C";
    }
}