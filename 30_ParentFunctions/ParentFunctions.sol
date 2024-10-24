// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title 基础合约 Base
/// @dev 基础合约包含两个函数，并使用事件记录日志
contract Base {
    event Log(string message);

    function foo() public virtual {
        emit Log("Base: foo called");
    }

    function bar() public virtual {
        emit Log("Base: bar called");
    }
}

/// @title 子合约 ChildA
/// @dev 继承 Base，覆盖 foo 和 bar 函数
contract ChildA is Base {
    function foo() public virtual override {
        emit Log("ChildA: foo called");
    }

    function bar() public virtual override {
        emit Log("ChildA: bar called");
    }
}

/// @title 子合约 ChildB
/// @dev 继承 Base，覆盖 foo 和 bar 函数
contract ChildB is Base {
    function foo() public virtual override {
        emit Log("ChildB: foo called");
    }

    function bar() public virtual override {
        emit Log("ChildB: bar called");
    }
}

/// @title 最终合约 FinalContract
/// @dev 继承 ChildA 和 ChildB，演示直接调用和使用 super 调用父合约的区别
contract FinalContract is ChildA, ChildB {
    
    /// @dev 重写 foo 函数，并使用 super 关键字调用继承链中的 foo 函数
    function foo() public virtual override(ChildA, ChildB) {
        super.foo(); // 使用 super 调用 foo，依照继承链调用
    }

    /// @dev 重写 bar 函数，并使用 super 关键字调用继承链中的 bar 函数
    function bar() public virtual override(ChildA, ChildB) {
        super.bar(); // 使用 super 调用 bar，依照继承链调用
    }

    /// @dev 使用直接调用的方式调用 ChildA 和 ChildB 中的 foo 函数
    function callDirectly() public {
        ChildA.foo(); // 直接调用 ChildA 的 foo
        ChildB.foo(); // 直接调用 ChildB 的 foo
    }
}