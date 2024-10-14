// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract IfElse {
    function processNumber(int x) public pure returns (string memory){
        if (x < 10){
            // 使用 Unicode 字符串前缀, Solidity 不支持直接在字符串中使用非 ASCII 字符（例如中文字符）
            return unicode"小于10";
        }else  if (x < 20) {
            return unicode"介于10到20";
        }
        return unicode"大于20";
    }
     function processNumber2(int x) public pure returns (string memory){
        
        return  x < 10? unicode"小于10" : x < 20 ?   unicode"小于20" :   unicode"大于20";
    
    }

    function transfer(uint _amount) public pure  returns (string memory){
        // require(condition, message)：当条件不满足时，抛出异常，返回指定的错误消息。常用于输入参数检查或函数调用的前置条件
        require(_amount > 10, unicode"金额错误");
        return unicode"成功";
    }
    // revert()：手动回滚交易。
    function checkAndRevert(uint _value) public pure {
        if (_value == 0) {
            // 如果 _value 为 0，手动回滚交易
            revert("Value cannot be zero");
        }
    }

}
// assert(condition)：用于检查不应该出现的条件，通常用于调试或不可变条件。
contract Token {
    uint public totalSupply;
    mapping(address => uint) public balances;

    constructor(uint _initialSupply) {
        totalSupply = _initialSupply;
        balances[msg.sender] = _initialSupply;
    }

    function transfer(address _to, uint _amount) public {
        // 检查发送者有足够的余额
        require(balances[msg.sender] >= _amount, "Insufficient balance");

        // 转账
        balances[msg.sender] -= _amount;
        balances[_to] += _amount;

        // 使用 assert 确保代币总供应量不变
        assert(balances[msg.sender] + balances[_to] <= totalSupply);
    }
}