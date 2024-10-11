// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract Counter {
    uint public  count;

     uint256 public defaultUint;   // 默认值为 0
    int256 public defaultInt;     // 默认值为 0
    bool public defaultBool;      // 默认值为 false
    address public defaultAddress;  // 默认值为 0x0000000000000000000000000000000000000000
    string public defaultString;  // 默认值为空字符串 ""
    bytes public defaultBytes;    // 默认值为空字节数组 0x
    uint256[] public defaultArray;  // 默认值为空数组 []
    
    enum Status { Pending, Shipped, Delivered }
    Status public defaultEnum;    // 默认值为枚举的第一个成员 Pending (0)
    
    // 映射的默认行为是，对于任何不存在的键，返回值类型的默认值
    mapping(address => uint256) public defaultMapping;  // 不存在的键返回 0
    
    function increase() external {
        count += 1;
    }
    function decrease() external {
        count -= 1;
    }

     // 定义一个常量
    uint256 public constant MY_CONSTANT = 100;

    // 定义一个普通状态变量
    uint256 public myVariable = 100;

    // 获取常量  398
    function getConstant() public pure returns (uint256) {
        return MY_CONSTANT;
    }

    // 获取普通状态变量  2455
    function getVariable() public view returns (uint256) {
        return myVariable;
    }
}