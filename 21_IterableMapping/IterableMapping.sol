// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract IterableBalances {
    
    // 映射：存储每个地址的余额
    mapping(address => uint) public balances;
    
    // 数组：存储所有插入过的地址
    address[] public keys;
    
    // 辅助映射：跟踪是否已经插入过某个地址
    mapping(address => bool) private inserted;

    // 向映射中添加或更新地址和余额
    function set(address _key, uint _value) public {
        // 如果地址是第一次插入，则添加到 keys 数组
        if (!inserted[_key]) {
            inserted[_key] = true;
            keys.push(_key);
        }
        // 更新 balances 映射中的余额
        balances[_key] = _value;
    }

    // 获取 keys 数组的长度
    function getSize() public view returns (uint) {
        return keys.length;
    }

    // 根据索引返回相应地址的余额
    function getBalanceAtIndex(uint index) public view returns (uint) {
        require(index < keys.length, "Index out of bounds");
        address key = keys[index];
        return balances[key];
    }
}