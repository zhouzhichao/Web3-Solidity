// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface ICounter {
    function getCount() external view returns (uint); // 根据解决方案 1
    function increment() external;
}