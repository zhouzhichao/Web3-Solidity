// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

//
contract valueTypes {
    bool public b = true;
    uint public u = 256; // uint256  0 ~ 2**256-1
                         // uint8 0~2**8 -1
                         // uint16 0 ~ 2**16 -1
    int public  i = -128;  // int = int256   -2**255 ~ 2**255 -1
                            // int128 -2 **127 ` 2**127-1
    
    int public minInt = type(int).min;
    int public maxInt =  type(int).max;
    address public addr = 0xAb5801a7D398351b8bE11C439e05C5B3259aeC9B;
    bytes32 data = "Hello, World!";  // 固定长度的字节数据

}