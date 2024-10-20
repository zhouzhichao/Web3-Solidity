# Solidity 简单存储 (Simple Storage)

一个 **简单存储 (Simple Storage)** 智能合约通常用于展示如何在区块链上存储和读取数据。这个合约的核心功能是允许用户在区块链上存储一个值，并且允许其他人读取该值。
以下是一个典型的 **简单存储合约** 的实现，它展示了如何使用 Solidity 来存储和检索整数值。

### Solidity 智能合约代码：简单存储 (Simple Storage)

```Solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleStorage {

    // 存储一个整数
    uint256 public storedData;

    // 设置 storedData 的值
    function set(uint256 x) public {
        storedData = x;
    }

    // 获取 storedData 的值（由于 storedData 是 public，这里不一定需要这个函数）
    function get() public view returns (uint256) {
        return storedData;
    }
}
```

### 功能说明

1. **状态变量** **`storedData`**:
  1. `storedData` 是合约的状态变量，用于存储一个 `uint256` 类型的整数。
    
  2. 由于它是 `public` 的，Solidity 会自动生成一个 getter 函数来允许外部访问这个值。
    
2. **`set(uint256 x)`** **函数**:
  1. 允许用户通过传递一个参数 `x` 来设置 `storedData` 的值。
    
  2. 这个函数是 `public` 的，意味着任何人都可以调用它，并且它会修改合约中的状态变量，消耗 `gas`。
    
3. **`get()`** **函数**:
  1. 这是一个 `view` 函数（只读操作），允许用户查看当前存储的值。
    
  2. 由于 `storedData` 是 `public` 的，Solidity 已经自动生成了一个 getter 函数，因此这个 `get()` 函数实际上是多余的，直接访问 `storedData` 也可以获取相同的值。
    

### 合约的核心功能

- **存储数据（set）**：
  - 用户可以通过调用 `set()` 函数来存储数据。例如，用户可以将数字 `42` 存储到合约的状态变量 `storedData` 中。
    

```Solidity
set(42);  // 将 42 存储到 storedData
```

- **读取数据（get）**：
  - 用户可以通过调用 `get()` 函数来读取已经存储的数据，或者直接通过 `storedData()` 来获取当前存储的值。
    

```Solidity
uint value = get();  // 读取当前存储的值
// 或者，直接使用自动生成的 getter:
uint value = storedData();
```

### 合约的使用示例

1. **设置值**：
  1. 假设当前合约已经部署在区块链上，用户可以调用以下命令来设置 `storedData` 的值为 `100`：
    

```Solidity
set(100);
```

1. 这个操作会消耗一定的 `gas`，因为它修改了合约的状态。
  
2. **读取值**：
  1. 一旦 `storedData` 的值被设置，任何用户都可以通过调用以下命令来读取当前存储的值：
    

```Solidity
uint value = get();  // 返回 100
```

1. 或者，用户可以直接访问 `storedData()`，因为 `storedData` 是 `public` 的：
  

```Solidity
uint value = storedData();  // 返回 100
```

1. 由于这是一个只读操作，它不会消耗 `gas`。
  

### 总结

- 这是一个非常简单的存储合约，展示了如何在区块链上存储和读取整数值。
  
- 合约中的 `set()` 函数允许用户存储一个整数，而 `get()` 函数允许用户读取该整数。
  
- 由于状态变量 `storedData` 是 `public` 的，自动生成的 getter 函数使得 `get()` 函数实际上是冗余的，用户可以直接通过 `storedData()` 来读取值。
  

### 扩展功能

这个简单的存储合约可以进一步扩展，以支持更多的功能，例如：

- **支持多个用户的存储**：通过使用 `mapping`，可以为每个用户单独存储一个值。
  
- **支持更多的****数据类型**：不仅限于存储整数，还可以存储字符串、数组、结构体等数据类型。
  
- **增加权限控制**：通过引入权限机制，限制只有特定用户可以设置或修改存储的值。
  

```Solidity
// 扩展：多用户存储
pragma solidity ^0.8.0;

contract MultiUserStorage {

    // 定义一个 mapping，用于存储每个用户的值
    mapping(address => uint256) public userStorage;

    // 设置用户的存储值
    function set(uint256 x) public {
        userStorage[msg.sender] = x;
    }

    // 获取当前用户的存储值
    function get() public view returns (uint256) {
        return userStorage[msg.sender];
    }
}
```

在扩展的合约中，`userStorage` 是一个 `mapping`，用于存储每个用户的值。调用 `set()` 函数的用户只能修改自己存储的值，而不是其他用户的值。