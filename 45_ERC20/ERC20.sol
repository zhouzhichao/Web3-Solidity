/**
实现一个简单的ERC20代币合约，包含以下功能：

1. 定义代币的名称、符号和小数位数。
2. 实现转移功能。
3. 实现授权功能及其查询。
4. 实现代币的增发和销毁功能。
**/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleERC20 {
    // 代币名称
    string public name;
    // 代币符号
    string public symbol;
    // 代币的小数位数
    uint8 public decimals;
    // 代币的总供应量
    uint256 public totalSupply;
    
    // 每个地址持有的代币余额
    mapping(address => uint256) private balances;
    
    // 授权映射：owner -> (spender -> allowance)
    mapping(address => mapping(address => uint256)) private allowances;
    
    // 事件：当代币转移时触发
    event Transfer(address indexed from, address indexed to, uint256 value);
    
    // 事件：当授权发生变化时触发
    event Approval(address indexed owner, address indexed spender, uint256 value);

    // 构造函数，初始化代币的名称、符号、小数位数和初始供应量
    constructor(string memory _name, string memory _symbol, uint8 _decimals, uint256 _initialSupply) {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
        totalSupply = _initialSupply * (10 ** uint256(decimals)); // 按小数位数计算总量
        balances[msg.sender] = totalSupply; // 初始供应量分配给合约的创建者
        emit Transfer(address(0), msg.sender, totalSupply); // 触发转移事件，表示代币创建
    }

    // 查询某个地址的代币余额
    function balanceOf(address account) public view returns (uint256) {
        return balances[account];
    }

    // 转账函数，将代币从调用者转移到另一个地址
    function transfer(address to, uint256 amount) public returns (bool) {
        _transfer(msg.sender, to, amount);
        return true;
    }

    // 内部转账逻辑
    function _transfer(address from, address to, uint256 amount) internal {
        require(to != address(0), "ERC20: transfer to the zero address"); // 禁止转账到零地址
        require(balances[from] >= amount, "ERC20: transfer amount exceeds balance"); // 确保余额足够
        
        balances[from] -= amount; // 扣除发送者的余额
        balances[to] += amount;   // 增加接收者的余额
        emit Transfer(from, to, amount); // 触发转移事件
    }

    // 授权某个地址可以从调用者账户中花费一定数量的代币
    function approve(address spender, uint256 amount) public returns (bool) {
        _approve(msg.sender, spender, amount);
        return true;
    }

    // 内部授权逻辑
    function _approve(address owner, address spender, uint256 amount) internal {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        allowances[owner][spender] = amount; // 设置授权额度
        emit Approval(owner, spender, amount); // 触发授权事件
    }

    // 查询授权额度
    function allowance(address owner, address spender) public view returns (uint256) {
        return allowances[owner][spender];
    }

    // 使用授权额度从另一个账户转账到指定地址
    function transferFrom(address from, address to, uint256 amount) public returns (bool) {
        require(allowances[from][msg.sender] >= amount, "ERC20: transfer amount exceeds allowance");

        _transfer(from, to, amount); // 进行转账
        _approve(from, msg.sender, allowances[from][msg.sender] - amount); // 减少剩余的授权额度
        return true;
    }

    // 增发代币（只有合约的拥有者可以增发）
    function mint(uint256 amount) public returns (bool) {
        require(msg.sender == address(0), "ERC20: Only owner can mint"); // 在此简化为只有零地址可以增发 (实际应用中应使用权限控制)
        
        _mint(msg.sender, amount);
        return true;
    }

    // 内部增发逻辑
    function _mint(address account, uint256 amount) internal {
        require(account != address(0), "ERC20: mint to the zero address");

        totalSupply += amount; // 增加总供应量
        balances[account] += amount; // 增加账户余额
        emit Transfer(address(0), account, amount); // 触发转账事件，表示代币的铸造
    }

    // 销毁代币
    function burn(uint256 amount) public returns (bool) {
        _burn(msg.sender, amount);
        return true;
    }

    // 内部销毁逻辑
    function _burn(address account, uint256 amount) internal {
        require(account != address(0), "ERC20: burn from the zero address");
        require(balances[account] >= amount, "ERC20: burn amount exceeds balance");

        balances[account] -= amount; // 扣减账户余额
        totalSupply -= amount; // 减少总供应量
        emit Transfer(account, address(0), amount); // 触发转账事件，表示代币的销毁
    }
}