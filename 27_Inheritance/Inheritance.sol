// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// ContractA 定义了两个函数 foo() 和 bar()，返回 "A"
contract ContractA {
    // 返回字符串 "A"
    function foo() public virtual pure returns (string memory) {
        return "A";
    }

    // 返回字符串 "A"
    function bar() public virtual pure returns (string memory) {
        return "A";
    }
}

// ContractB 继承 ContractA，重写 foo() 和 bar()，返回 "B"
contract ContractB is ContractA {
    // 重写 foo()，返回字符串 "B"
    function foo() public virtual override pure returns (string memory) {
        return "B";
    }

    // 重写 bar()，返回字符串 "B"
    function bar() public virtual override pure returns (string memory) {
        return "B";
    }
}

// ContractC 继承 ContractB，只重写 bar()，返回 "C"
contract ContractC is ContractB {
    // 重写 bar()，返回字符串 "C"
    function bar() public override pure returns (string memory) {
        return "C";
    }
}