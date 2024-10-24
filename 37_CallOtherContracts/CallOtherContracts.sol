// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MyTargetContract {
    uint public x;
    uint public valueReceived;

    // 设置x的值
    function setX(uint _x) public {
        x = _x;
    }

    // 获取x的值
    function getX() public view returns (uint) {
        return x;
    }

    // 设置x的值并接收以太币
    function setXAndReceiveEther(uint _x) public payable {
        x = _x;
        valueReceived = msg.value;  // 记录收到的以太币
    }

    // 返回x的值和合约当前持有的以太币
    function getXAndValue() public view returns (uint, uint) {
        return (x, address(this).balance);
    }
}