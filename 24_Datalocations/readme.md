# Solidity 存储、内存和调用数据 (Storage, Memory and Calldata)

在 Solidity 中，变量的存储位置（`storage`、`memory` 和 `calldata`）非常重要，因为它们直接影响到变量的生命周期、可修改性和 gas 成本。

### 1. **存储 (Storage)**

- `storage` 是一种永久存储，数据会保存在合约的存储中，类似于区块链的硬盘。
  
- 变量存储在 `storage` 中时，它们会占用链上的空间，并且在合约的生命周期中永久存在，直到显式修改或删除。
  
- **默认情况下，状态变量**（即在合约中定义的变量）存储在 `storage` 中。
  

#### 示例

```Solidity
pragma solidity ^0.8.0;contract StorageExample {    uint public storedData;  // 状态变量，存储在 storage 中    function set(uint x) public {        storedData = x;      // 修改 storage 中的变量    }}
```

在上面的例子中，`storedData` 是一个状态变量，存储在 `storage` 中，是合约长期保存的数据。

### 2. **内存** **(Memory)**

- `memory` 是临时存储，仅在函数调用期间存在，函数执行完毕后数据会被销毁。
  
- 函数参数、局部变量、返回值，尤其是复杂类型（如数组、结构体、字符串等）在函数内使用时，通常会使用 `memory`。
  
- `memory` 中的数据是可修改的，但它不持久化。
  

#### 示例

```Solidity
pragma solidity ^0.8.0;contract MemoryExample {    // 将字符串复制到 memory 中    function getMemoryString() public pure returns (string memory) {        string memory tempString = "Hello, World!";        return tempString;  // 返回 memory 中的字符串    }}
```

在这个例子中，`tempString` 是一个 `memory` 类型的变量，它只在 `getMemoryString()` 函数调用期间存在，一旦函数返回，数据就会被销毁。

### 3. **调用数据 (Calldata)**

- `calldata` 是一种特殊的存储位置，专门用于 **函数参数** 的传递。它是不可修改的，数据存储在调用者传递的上下文中。
  
- `calldata` 通常用于外部函数调用的参数，因为它比 `memory` 更节省 gas。
  
- `calldata` 变量是只读的，不能修改。
  

#### 示例

```Solidity
pragma solidity ^0.8.0;contract CalldataExample {    // 使用 calldata 传递参数，节省 gas，且不可修改    function processCalldata(string calldata inputString) public pure returns (string memory) {        // inputString 是 calldata 类型，不能修改        return inputString;  // 返回传入的字符串    }}
```

在这个例子中，`inputString` 是 `calldata` 类型的变量，它是不可修改的。调用者传递的上下文数据直接存储在 `calldata` 中，节省了存储空间和 gas。

### 总结

- **`storage`**：永久存储在链上，适用于状态变量。修改 `storage` 中的数据会消耗较多的 `gas`。
  
- **`memory`**：临时存储，用于局部变量和函数调用期间的数据存储。适合在函数内计算和操作临时数据。
  
- **`calldata`**：只读的函数参数存储，适用于外部函数调用时传递的数据，节省 `gas`，但不可修改。
  

### 变量默认存储位置

1. **状态变量**：
  1. 默认存储在 `storage` 中，因为它们需要持久化存储在区块链上。
    
2. **函数参数**：
  1. 对于外部函数（`external`），非值类型（如数组、字符串）参数默认存储在 `calldata` 中。
    
  2. 对于内部函数（`internal` 或 `public`），非值类型参数默认存储在 `memory` 中。
    
3. **局部变量**：
  1. 非值类型的局部变量（如数组、结构体）默认存储在 `memory` 中，除非显式声明为 `storage`。
    

### 示例：使用 `storage`、`memory` 和 `calldata`

```Solidity
pragma solidity ^0.8.0;contract StorageMemoryCalldataExample {    // 定义一个状态变量 (storage)    string public storedData = "Initial Data";    // 修改 storage 中的状态变量    function updateStoredData(string memory newData) public {        storedData = newData;  // 这里更新的是 storage    }    // 处理 memory 中的数据    function processMemoryData(string memory tempData) public pure returns (string memory) {        string memory localData = tempData;        return localData;  // 返回 memory 中的数据    }    // 使用 calldata 传递只读数据    function processCalldataData(string calldata inputData) public pure returns (string memory) {        return inputData;  // 返回 calldata 中的数据    }}
```

### 详细解释

1. **`storage`**：在 `updateStoredData()` 函数中，`storedData` 是一个状态变量，存储在 `storage` 中。当我们更新它时，链上的数据会被修改，这需要消耗较多的 `gas`。
  
2. **`memory`**：在 `processMemoryData()` 函数中，`tempData` 是一个 `memory` 类型的局部变量，它只会在函数执行期间存在，函数执行完毕后即会销毁。
  
3. **`calldata`**：在 `processCalldataData()` 函数中，`inputData` 是一个 `calldata` 类型的参数。它是只读的，我们无法修改它，但这种方式比使用 `memory` 更节省 `gas`。
  

### 存储位置的 gas 成本差异

- **`storage`** 操作最昂贵，因为它涉及到对区块链永久存储的读写。
  
- **`memory`** 操作比 `storage` 便宜，但它需要在 EVM 中分配和释放内存。
  
- **`calldata`** 是最便宜的，因为它是只读的，并且不涉及额外的内存分配。
  

### 总结

- 使用 `storage` 存储需要长期保存的数据，但要尽量减少不必要的 `storage` 写操作，因为它们非常昂贵。
  
- 使用 `memory` 处理临时数据，适合函数内部的计算，但它在函数执行完毕后就会被销毁。
  
- 使用 `calldata` 存储只读的函数参数，特别是在外部函数调用中，这种方式可以有效节省 `gas`。