// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract SimpleBank {
    
    // 创建一个公开的映射，存储每个地址的余额
    mapping(address => uint) public balances;

    // 存款函数：允许用户为自己的账户存款
    function deposit() public payable {
        require(msg.value > 0, "Deposit amount must be greater than zero");
        balances[msg.sender] += msg.value;  // 增加余额
    }

    // 提款函数：允许用户从自己的账户提取指定金额
    function withdraw(uint amount) public {
        require(amount > 0, "Withdraw amount must be greater than zero");
        require(balances[msg.sender] >= amount, "Insufficient balance");

        balances[msg.sender] -= amount;     // 减少余额
        payable(msg.sender).transfer(amount);  // 将金额转账给用户
    }

    // 检查余额函数：返回调用者的当前余额
    function checkBalance() public view returns (uint) {
        return balances[msg.sender];
    }
}

/**
安全性与边界条件
边界条件：
deposit() 函数使用了 require 检查，确保用户存款金额大于零。
withdraw() 函数使用了 require 检查，确保用户的余额足够时才允许提现，并且提现金额必须大于零。
合约安全性：
withdraw() 函数中的资金转移使用了 transfer()，它自动限制了调用的 gas 消耗，减少了重入攻击的风险。
**/