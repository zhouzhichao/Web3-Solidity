// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract LocalVariables {
    uint public  a = 0;
    bool public  b = false;
    address public myAddress = address(0);

    function updateVariables() public {
        uint x = 123;
        bool y = false;

        x += 256;

        y = true;

        b = true;

        a = 22;

        myAddress =address(1);
    }

}