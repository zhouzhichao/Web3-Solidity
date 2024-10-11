// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract GlobalInfoView {
    function viewGlobalInfo() external view returns (address, uint,uint) {
        address sender = msg.sender; // 调用合约的账户（外部账户或合约地址）。
        uint timestamp = block.timestamp;
        uint blockNum = block.number; // 当前区块的编号（高度）
        return (sender, timestamp, blockNum);
    }
    function getTransactionInfo() public view  returns (uint256, address) {
        // tx.gasprice	uint	当前交易的 Gas 价格（每单位 Gas 的价格）。
        // tx.origin	address	当前交易的来源账户（外部账户或合约地址）。
        return (tx.gasprice, tx.origin);
    }

}