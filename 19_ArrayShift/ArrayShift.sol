/**
创建一个Solidity智能合约函数，该函数接受一个整数数组和一个索引作为参数，
根据上述方法移除索引指定的元素并返回新数组。请包括对边界情况的处理，确保当数组为空或索引超出范围时，
能够正确反馈错误信息。
**/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ArrayElementRemover {

    // 删除指定索引的元素，并返回新的数组
    function removeElement(uint[] memory arr, uint index) public pure returns (uint[] memory) {
        // 边界情况处理：检查数组是否为空
        require(arr.length > 0, "Array is empty");
        
        // 边界情况处理：检查索引是否超出范围
        require(index < arr.length, "Index out of bounds");

        // 创建一个新的数组，长度比原数组小 1
        uint[] memory newArray = new uint[](arr.length - 1);

        // 将元素从原数组复制到新数组，跳过指定索引
        for (uint i = 0; i < index; i++) {
            newArray[i] = arr[i];
        }
        
        for (uint i = index; i < arr.length - 1; i++) {
            newArray[i] = arr[i + 1];
        }

        return newArray;
    }
}