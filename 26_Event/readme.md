# Solidity 事件

在 Solidity 中，事件（Events） 是一种机制，它允许智能合约与外部世界（如用户界面或其他应用程序）进行通信。事件会记录在区块链的交易日志中，前端应用程序可以通过监听这些事件来检测合约中发生的某些操作或状态变化。

### 事件的工作原理

事件在 Solidity 中是通过 `emit` 关键字触发的，并且它们会被记录在区块链的交易日志中。交易日志是以太坊的一部分，它存储在区块链中，并且可以通过交易哈希和合约地址进行查询。

### 事件的使用场景

- 通知前端应用程序合约中的状态变化。
  
- 作为便捷的日志记录，方便调试和审计。
  
- 在不需要存储的情况下，通过事件传递信息，节省 `gas` 成本。
  

### 事件的声明与触发

事件的声明与函数类似，但没有返回值。事件可以包含多个参数，这些参数在事件被触发时会作为交易的一部分保存在区块链上。

### 示例：使用事件记录任务的创建与完成

```Solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ToDoList {

    // 定义一个 ToDo 结构体，包含任务描述和完成状态
    struct ToDo {
        string text;         // 任务描述
        bool completed;      // 是否完成
    }

    // 任务列表
    ToDo[] public todos;

    // 事件：当任务创建时触发
    event TaskCreated(uint taskIndex, string text);

    // 事件：当任务状态改变时触发
    event TaskCompleted(uint taskIndex, bool completed);

    // 创建新任务
    function createTask(string calldata _text) external {
        todos.push(ToDo({
            text: _text,
            completed: false
        }));

        // 触发事件，告知外部新任务已经创建
        emit TaskCreated(todos.length - 1, _text);
    }

    // 切换任务的完成状态
    function toggleCompleted(uint _index) external {
        require(_index < todos.length, "Invalid task index");

        // 切换任务的完成状态
        todos[_index].completed = !todos[_index].completed;

        // 触发事件，告知外部任务的完成状态已经改变
        emit TaskCompleted(_index, todos[_index].completed);
    }
}
```

### 代码说明

1. **`TaskCreated`** **事件**：
  1. 当用户调用 `createTask` 函数时，合约会触发 `TaskCreated` 事件，通知前端应用程序新的任务已创建。
    
  2. `TaskCreated` 事件有两个参数：
    - `taskIndex`: 任务在 `todos` 数组中的索引，方便前端根据索引找到任务。
      
    - `text`: 任务的描述，向前端传递该任务的具体内容。
      
2. **`TaskCompleted`** **事件**：
  1. 当用户调用 `toggleCompleted` 函数切换任务的完成状态时，合约会触发 `TaskCompleted` 事件，通知前端应用程序任务的完成状态已改变。
    
  2. `TaskCompleted` 事件有两个参数：
    - `taskIndex`: 任务的索引。
      
    - `completed`: 任务是否已完成（布尔类型）。
      
3. **触发事件**：
  1. 事件是通过 `emit` 关键字来触发的，如 `emit TaskCreated(taskIndex, text)`。
    
  2. 事件不会改变合约的状态，它们只是记录信息并传递给监听者（例如前端应用程序）。
    

### 如何监听事件

在前端应用程序中，可以使用 Web3.js 或 Ethers.js 来监听 Solidity 合约事件。

#### 使用 Web3.js 监听事件

```JavaScript
const Web3 = require('web3');
const web3 = new Web3('https://ropsten.infura.io/v3/YOUR_INFURA_PROJECT_ID');
const contractABI = [...] // 合约 ABI
const contractAddress = "0xYourContractAddress";

const contract = new web3.eth.Contract(contractABI, contractAddress);

// 监听 TaskCreated 事件
contract.events.TaskCreated({
    fromBlock: 0
}, (error, event) => {
    if (!error) {
        console.log("Task Created: ", event.returnValues);
    }
});

// 监听 TaskCompleted 事件
contract.events.TaskCompleted({
    fromBlock: 0
}, (error, event) => {
    if (!error) {
        console.log("Task Completed: ", event.returnValues);
    }
});
```

### Indexed 事件参数

事件的参数可以设置为 `indexed`，使它们成为可过滤的，允许更高效地查询和监听特定事件。例如，如果你想通过任务的 `taskIndex` 来查询或过滤事件，可以将 `taskIndex` 标记为 `indexed`。
修改事件声明以使 `taskIndex` 可过滤：

```Solidity
// 事件：当任务创建时触发
event TaskCreated(uint indexed taskIndex, string text);

// 事件：当任务状态改变时触发
event TaskCompleted(uint indexed taskIndex, bool completed);
```

在前端，你可以像这样过滤特定的事件：

```JavaScript
// 只监听特定 taskIndex 的 TaskCompleted 事件
contract.getPastEvents('TaskCompleted', {
    filter: { taskIndex: 1 }, // 只监听 taskIndex 为 1 的事件
    fromBlock: 0,
    toBlock: 'latest'
}, (error, events) => {
    if (!error) {
        console.log(events);
    }
});
```

### 事件的 `gas` 成本

- 触发事件本身需要 `gas`，但相对于存储数据，它的成本较低。
  
- 事件记录在交易日志中，日志不能从合约内部访问，因此它们不会消耗合约的存储空间。
  
- `indexed` 参数可以在事件日志中更高效地搜索和过滤，但它们的 `gas` 成本会略高一些。
  

### 事件的限制

- 事件最多可以有 **3 个** **`indexed`** **参数**。
  
- 总参数数量不能超过 **4 个**（包括 `indexed` 和非 `indexed` 参数）。
  
- 事件的日志只能从外部访问，合约不能读取事件的日志。
  

### 总结

- **事件** 是一种高效的方式来通知外部世界合约的状态变化。
  
- 它们被记录在区块链的交易日志中，可以从外部（如前端应用程序）进行查询和监听。
  
- **`emit`** 关键字用于触发事件。
  
- 事件的参数可以被 `indexed`，从而允许更高效的查询和过滤。