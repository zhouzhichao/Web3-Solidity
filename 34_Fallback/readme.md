# Solidity 后备

在 Solidity 中，`fallback` 函数和 `receive` 函数是合约中的特殊函数，通常用于处理合约接收以太币时的逻辑，或者处理错误的函数调用。它们统称为合约的“后备机制”（Fallback Mechanism），当外部调用的函数不存在时，或者当以太币直接发送到合约时，这些函数会被触发。

### `fallback()` 函数

`fallback()` 是一个特殊的函数，用于处理以下两种情况：

1. 当合约接收到以太币 **且没有匹配的函数** 时（如果没有 `receive()` 函数，`fallback()` 函数会接收以太币）。
  
2. 当合约接收到的数据不匹配任何已存在的函数签名时。
  

`fallback()` 函数有以下特点：

- 它是 `external` 函数。
  
- 可以是 `payable`，如果希望合约在这种情况下接收以太币。
  
- 如果不希望接收以太币但仍想处理未匹配函数的调用，`fallback()` 函数可以不使用 `payable`，并且可以返回错误信息。
  
- `fallback()` 函数没有参数，也没有返回值。
  

### `receive()` 函数

`receive()` 是 Solidity 0.6.0 引入的一个特殊函数，它是专门用来接收**没有附带数据**的以太币的。它的触发条件是：

- 直接向合约发送以太币（例如通过 `transfer()` 或 `send()`）。
  
- 没有附带任何函数调用的数据。
  

`receive()` 函数有以下特点：

- 它是 `external` 和 `payable` 的。
  
- 不能有输入参数，也不能有返回值。
  
- 如果合约没有定义 `receive()` 函数，那么 `fallback()` 函数会代替它来接收以太币。
  

### `fallback` 和 `receive` 函数的区别

- **`receive()`** **函数**：只在合约接收到没有附带数据的以太币时调用。
  
- **`fallback()`** **函数**：当调用了不存在的函数、或发送了带有数据的以太币时调用。如果合约没有 `receive()` 函数且直接发送以太币，也会调用 `fallback()`。
  

### 示例：带有 `fallback()` 和 `receive()` 函数的合约

```Solidity
// SPDX-License-Identifier: MITpragma solidity ^0.8.0;contract FallbackExample {    // 定义事件，用于记录日志    event LogFallbackCalled(address sender, uint amount, string message);    event LogReceiveCalled(address sender, uint amount);    // receive 函数：用于接收没有附带数据的以太币    receive() external payable {        emit LogReceiveCalled(msg.sender, msg.value);    }    // fallback 函数：用于处理不存在的函数调用或带有数据的以太币转账    fallback() external payable {        emit LogFallbackCalled(msg.sender, msg.value, "Fallback called: Non-existent function or incorrect data");    }    // 返回合约的余额    function getBalance() public view returns (uint) {        return address(this).balance;    }}
```

### 代码说明

1. **`receive()`** **函数**：
  1. 该函数用于接收没有附带数据的以太币。当向合约发送以太币且不调用任何函数时，`receive()` 函数会被触发。
    
  2. 在 `receive()` 函数中，触发了一个事件 `LogReceiveCalled`，记录发送者的地址和发送的以太币数量。
    
2. **`fallback()`** **函数**：
  1. 当调用不存在的函数，或发送带有数据的以太币时，`fallback()` 函数会被触发。
    
  2. 在 `fallback()` 函数中，触发了一个事件 `LogFallbackCalled`，记录发送者的地址、发送的以太币数量，以及一条描述错误的消息。
    
  3. 由于 `fallback()` 函数是 `payable`，它也能接收以太币。
    
3. **`getBalance()`** **函数**：
  1. 这是一个辅助函数，用于返回合约当前的以太币余额。
    
  2. `address(this).balance` 返回合约的以太币余额。
    

### 测试步骤

4. 向合约发送以太币（没有调用任何函数）
  

- 在 Remix 或其他开发工具中，直接向合约发送以太币（不附带任何数据）。
  
- 这将触发 `receive()` 函数，并在事件日志中记录 `LogReceiveCalled` 事件。
  

5. 调用不存在的函数
  

- 在 Remix 中，尝试调用一个不存在的函数，例如 `nonExistentFunction()`，或者发送带有数据的以太币。
  
- 这将触发 `fallback()` 函数，并在事件日志中记录 `LogFallbackCalled` 事件。
  

6. 查询合约余额
  

- 调用 `getBalance()`，查看合约的余额，确保合约接收了以太币。
  

### 注意事项

1. **`receive()`** **函数的存在**：如果存在 `receive()` 函数，那么向合约发送没有数据的以太币时将调用 `receive()` 函数。否则，将调用 `fallback()` 函数。
  
2. **限制** **`fallback()`** **函数的行为**：如果不希望合约接收以太币，可以在 `fallback()` 函数中使用 `revert()`，例如：
  

```Solidity
fallback() external payable {    revert("This contract does not accept Ether!");}
```

3. 这种方式可以确保当错误的函数被调用时，交易会回滚，并且不会接收任何以太币。
  
4. **避免滥用** **`fallback()`** **函数**：`fallback()` 函数应该尽可能简单，因为它可能会被频繁调用，特别是在错误的调用尝试中。复杂的逻辑可能会导致高额的 Gas 消耗。
  

### 总结

- **`receive()`**：专门用于接收没有附带数据的以太币转账。
  
- **`fallback()`**：处理任何不存在的函数调用，或者带有数据的以太币转账。也可以代替 `receive()` 函数接收以太币。
  
- 通过使用 `receive()` 和 `fallback()` 函数，你可以确保合约在需要时接收以太币，并且处理错误的调用。