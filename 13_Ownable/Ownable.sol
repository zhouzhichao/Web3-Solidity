// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract MyOwnable {
    address public  owner;

    uint public callCount; // 函数调用次数

    constructor() {
        owner = msg.sender;
        emit OwnershipTransferred(address(0), owner);
    }

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    modifier onlyOwner () {
        require(msg.sender == owner, "ERROR:: Not the Owner!");
        _;
    }

    function transferOwnership(address _newOwner) external onlyOwner {
        require(_newOwner !=address(0), "ERROR:: You cant transfer ownership to the null");
        emit OwnershipTransferred(owner, _newOwner);
        owner = _newOwner;
    }

    function call() public  {
        callCount += 1;
    }
    // 函数：只有拥有者可以调用，用于重置调用次数
    function resetCallCount() external onlyOwner {
        callCount = 0;
    }
        
}