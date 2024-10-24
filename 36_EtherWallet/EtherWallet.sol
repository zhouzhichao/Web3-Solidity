// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EtherWallet {

    // 合约拥有者地址
    address public owner;

    // 构造函数，在部署时设定合约拥有者
    constructor() {
        owner = msg.sender;
    }

    // 修饰符：确保只有拥有者可以调用
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    // fallback 和 receive 函数允许合约接收以太币
    receive() external payable {}

    // 返回合约当前的以太币余额
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }

    // 拥有者提取以太币到指定地址
    function withdraw(uint _amount) public onlyOwner {
        require(address(this).balance >= _amount, "Insufficient balance");
        payable(msg.sender).transfer(_amount);
    }
}