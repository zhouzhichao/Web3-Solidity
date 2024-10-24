# Solidity 不变性 (Immutable)

### 不变性（Immutable）变量

在 Solidity 中，不变性（`immutable`）变量是合约中声明后只能在**合约的构造函数中初始化**的状态变量，并且一旦初始化，它们的值在整个合约生命周期内都无法更改。`immutable` 变量的特性与 `constant` 类似，但它们允许在部署时进行初始化，而 `constant` 变量则必须在声明时初始化。
`immutable` 变量非常适合在部署时需要设置一次且之后不再改变的值，例如：合约的所有者地址、固定的交易费率、初始设置等。

### 使用 `immutable` 变量的优点

- **节省 Gas**：与普通状态变量相比，`immutable` 变量在访问时节省了存储读取的开销，因为它们的值存储在字节码中，而非在合约的存储槽中。
  
- **安全性**：由于 `immutable` 变量一旦初始化就不可改变，可以提高合约的安全性，避免某些值在运行时被意外或恶意更改。
  

### `immutable` 与 `constant` 的区别

1. **`constant`**：
  1. 必须在声明时初始化。
    
  2. 只能用于编译时已知的数值（如字面量）。
    
  3. 值在编译时固定，存储在字节码中。
    
2. **`immutable`**：
  1. 必须在**构造函数中**初始化。
    
  2. 可以用动态值（如构造函数的参数）初始化，但初始化后不可更改。
    
  3. 值在部署时设置，存储在字节码中（类似于 `constant`）。
    

### `immutable` 使用示例

```Solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ImmutableExample {

    // 不变的所有者地址，可以在构造函数中设置
    address public immutable owner;

    // 不变的初始值，可以在构造函数中设置
    uint public immutable initialValue;

    // 构造函数，初始化 immutable 变量
    constructor(uint _initialValue) {
        // 设置合约部署者为所有者
        owner = msg.sender;

        // 初始化初始值
        initialValue = _initialValue;
    }

    // 返回所有者地址
    function getOwner() public view returns (address) {
        return owner;
    }

    // 返回初始值
    function getInitialValue() public view returns (uint) {
        return initialValue;
    }
}
```

### 代码说明

1. **`owner`** **变量**：
  1. `owner` 是一个 `immutable` 变量，代表合约的所有者地址。它在合约部署时通过构造函数中的 `msg.sender` 初始化，并且在合约的生命周期内无法改变。
    
2. **`initialValue`** **变量**：
  1. `initialValue` 是另一个 `immutable` 变量，它的值通过构造函数接收的参数 `_initialValue` 进行初始化，并且初始化后无法修改。
    
3. **构造函数**：
  1. `owner` 和 `initialValue` 变量只能在构造函数中进行初始化。由于它们是 `immutable` 变量，它们在合约部署完成后将无法被修改。
    
4. **`getOwner`** **和** **`getInitialValue`** **函数**：
  1. 这些函数用于返回 `immutable` 变量的值，验证它们的设置是否正确。
    

### 部署和测试步骤

1. **部署合约**：
   在 Remix 或其他开发环境中，部署合约时需要提供一个 `uint` 类型的参数 `_initialValue`，这个值将被存储在 `immutable` 变量 `initialValue` 中。
  
2. **调用** **`getOwner()`**：
  1. 调用 `getOwner()` 函数，可以看到返回的地址是合约的部署者地址（`msg.sender`）。
    
3. **调用** **`getInitialValue()`**：
  1. 调用 `getInitialValue()` 函数，可以看到返回的值与部署合约时传入的 `_initialValue` 值一致。
    

### `immutable` 和 `constant` 的实际使用场景

#### `immutable` 变量的使用场景：

- **合约所有者地址**：可以在部署时设置合约的所有者地址，一旦设置后不可更改。
  
- **系统参数**：某些系统或协议参数只需在部署时确定，比如初始的交易费率、硬编码的区块高度等。
  

#### `constant` 变量的使用场景：

- **固定费率**：如果某些数值在编译时已知，例如固定的手续费率、最大供应量等，可以使用 `constant`。
  
- **数学常量**：例如 `PI`、`MAX_UINT` 等常量，可以在合约中使用 `constant` 声明。
  

### 示例：`immutable` 和 `constant` 结合使用

```Solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ConstantAndImmutable {

    // constant 变量，必须在声明时初始化
    uint public constant FIXED_FEE = 10;

    // immutable 变量，可以在构造函数中初始化
    address public immutable contractOwner;

    constructor() {
        // 初始化 immutable 变量
        contractOwner = msg.sender;
    }

    // 返回固定手续费
    function getFixedFee() public pure returns (uint) {
        return FIXED_FEE;
    }

    // 返回合约所有者
    function getContractOwner() public view returns (address) {
        return contractOwner;
    }
}
```

### 代码说明

1. `FIXED_FEE` 是一个 `constant` 变量，表示固定的手续费，它在声明时已初始化为 `10`，并且不能在运行时修改。
  
2. `contractOwner` 是一个 `immutable` 变量，它在构造函数中初始化为合约的部署者地址（`msg.sender`），并且在合约的生命周期内无法更改。
  

### 总结

- **`immutable`** **变量** 是合约中在部署时初始化、之后无法修改的状态变量。它们在节省 Gas 和确保状态不变性方面非常有用。
  
- **`constant`** **变量** 则用于编译时已知的固定值，通常用于数学常量或固定费率等场景。
  
- 使用 `immutable` 和 `constant` 可以提高合约的效率和安全性，同时减少不必要的存储开销。