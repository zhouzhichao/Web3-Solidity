// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Account.sol"; // 引入 Account 合约

contract AccountFactory {
    // 存储创建的 Account 合约地址
    Account[] public accounts;

    // 创建新的 Account 合约实例，并将其添加到数组中
    function createAccount(address _owner) public payable {
        // 使用 new 创建新的 Account 合约实例，并传递 _owner 地址
        Account newAccount = (new Account){value: msg.value}(_owner);

        // 将新创建的 Account 合约实例添加到 accounts 数组中
        accounts.push(newAccount);
    }

    // 获取所有创建的 Account 合约地址
    function getAccounts() public view returns (Account[] memory) {
        return accounts;
    }
}