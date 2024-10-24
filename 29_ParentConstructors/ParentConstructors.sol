// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title 合约 S
/// @dev 包含一个字符串状态变量 `name`，并通过构造函数进行初始化。
contract S {
    string public name;

    constructor(string memory _name) {
        name = _name;
    }
}

/// @title 合约 T
/// @dev 包含一个字符串状态变量 `text`，并通过构造函数进行初始化。
contract T {
    string public text;

    constructor(string memory _text) {
        text = _text;
    }
}

/// @title 合约 U
/// @dev 继承自合约 S 和 T，并在构造函数中调用 S 和 T 的构造函数。
contract U is S, T {
    constructor(string memory _name, string memory _text) S(_name) T(_text) {}
}

/// @title 合约 BB
/// @dev 继承自合约 S 和 T，静态传递 S 的构造函数参数，并动态传递 T 的构造函数参数。
contract BB is S("Static Name for S"), T {
    constructor(string memory _text) T(_text) {}
}

/// @title 合约 B0
/// @dev 继承顺序：先继承 S，再继承 T，验证构造函数调用顺序。
contract B0 is S, T {
    constructor(string memory _name, string memory _text) S(_name) T(_text) {}
}

/// @title 合约 B2
/// @dev 继承顺序：先继承 T，再继承 S，验证构造函数调用顺序。
contract B2 is T, S {
    constructor(string memory _name, string memory _text) S(_name) T(_text) {}
}