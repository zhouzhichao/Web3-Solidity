/**
任务：编写一个Solidity智能合约，其中包含一个动态数组和一个固定大小数组，实现以下功能：
1. 初始化两个数组，一个动态数组`nums`初始化为`[1, 2, 3]`，一个固定大小数组`fixedNums`初始化为`[4, 5, 6]`。
2. 提供一个函数插入元素到动态数组`nums`。
3. 提供一个函数返回动态数组`nums`中的指定索引的元素。
4. 提供一个函数用于更新动态数组`nums`中的元素。
5. 提供一个函数删除动态数组`nums`的指定索引的元素。
6. 提供一个函数返回动态数组`nums`的长度。
提交要求：提交完整的Solidity源代码，并确保所有函数按预期运行。
**/
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ArrayOperations {
    
    // 动态数组 nums，初始值为 [1, 2, 3]
    uint[] public nums = [1, 2, 3];
    
    // 固定大小数组 fixedNums，初始值为 [4, 5, 6]
    uint[3] public fixedNums = [4, 5, 6];
    
    // 插入新的元素到动态数组 nums 中
    function insertElement(uint _num) public {
        nums.push(_num);
    }

    // 返回动态数组 nums 中指定索引的元素
    function getElement(uint index) public view returns (uint) {
        require(index < nums.length, "Index out of bounds");
        return nums[index];
    }

    // 更新动态数组 nums 中的指定索引的元素
    function updateElement(uint index, uint _num) public {
        require(index < nums.length, "Index out of bounds");
        nums[index] = _num;
    }

    // 删除动态数组 nums 中指定索引的元素
    function deleteElement(uint index) public {
        require(index < nums.length, "Index out of bounds");
        for (uint i = index; i < nums.length - 1; i++) {
            nums[i] = nums[i + 1];  // 将后续元素左移
        }
        nums.pop();  // 删除最后一个元素
    }

    // 返回动态数组 nums 的长度
    function getLength() public view returns (uint) {
        return nums.length;
    }
}