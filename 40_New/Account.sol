/**
声明合约：
编写一个名为 Account 的合约，包含一个 owner 地址类型的状态变量，构造函数接收 owner 参数并初始化状态变量。
编写一个名为 AccountFactory 的合约，用于创建 Account 合约。
创建合约函数：
在 AccountFactory 合约中，创建一个名为 createAccount 的函数。
函数参数包括一个地址 owner，将其传递给 Account 合约的构造函数。
使用 new 关键字创建 Account 合约实例。
将新创建的 Account 实例添加到 accounts 数组中。
确保 createAccount 函数是 payable，并在创建合约时发送以太币。
部署和测试：
部署 AccountFactory 合约并调用 createAccount 函数，传递 owner 地址和一些以太币。
验证新创建的 Account 合约地址和所有者是否正确。
请完成上述合约并进行测试，确保新合约能够正确创建并接收以太币。
**/


// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Account {
    address public owner;

    // 构造函数，接收一个地址作为所有者
    constructor(address _owner) payable {
        owner = _owner;
    }
}