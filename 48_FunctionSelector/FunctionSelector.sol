// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Receiver {
    // 事件：记录 message.data (包含函数选择器和参数)
    event Log(bytes data);

    // transfer 函数，接收一个地址和一个金额
    function transfer(address _to, uint256 _amount) public {
        // 触发事件，记录 msg.data
        emit Log(msg.data);
    }
}

contract FunctionSelector {
    // 返回某个函数签名的前四字节哈希值（函数选择器）
    function getSelector(string memory _funcSignature) public pure returns (bytes4) {
        return bytes4(keccak256(bytes(_funcSignature)));
    }
}