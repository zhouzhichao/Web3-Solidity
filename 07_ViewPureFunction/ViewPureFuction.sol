// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract ViewPureContract {
    uint public  storeValue;
    constructor(uint initValue) {
        storeValue = initValue;
    }

    function multiply(int x, int y) public pure returns (int) {
        return x * y;
    }

    function getStoreValue() public view returns (uint) {
        return storeValue;
    }
    
}