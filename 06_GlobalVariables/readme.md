在 **Solidity** 中，**全局变量** 是一组由编译器内置、可以随时访问的特殊变量，它们提供与区块链和交易相关的重要信息。这些变量不需要声明，任何时候都可以直接使用。
这些全局变量通常用于获取当前区块、交易、消息发送者等重要的上下文信息。

### 全局变量的分类

Solidity 中的全局变量主要分为三类：

1. **区块相关的全局变量**：提供当前区块的信息。
  
2. **交易相关的全局变量**：提供当前交易的信息。
  
3. **消息相关的全局变量**：提供当前消息调用的信息。
  
4. 区块相关的全局变量
  

这些全局变量提供与当前区块相关的信息。
<style><!--br {mso-data-placement:same-cell;}--> td {white-space:nowrap;border:1px solid #dee0e3;font-size:10pt;font-style:normal;font-weight:normal;vertical-align:middle;word-break:normal;word-wrap:normal;}</style><byte-sheet-html-origin data-id="" data-version="4" data-is-embed="true" data-grid-line-hidden="false" data-copy-type="col"><table style="border-collapse: collapse;"><colgroup><col width="105"><col width="105"><col width="105"></colgroup><tbody><tr height="31"><td style="color:rgb(0, 0, 0);font-size:12pt;font-weight:bold;text-align:center;word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">全局变量</td><td style="color:rgb(0, 0, 0);font-size:12pt;font-weight:bold;text-align:center;word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">类型</td><td style="color:rgb(0, 0, 0);font-size:12pt;font-weight:bold;text-align:center;word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">描述</td></tr><tr height="53"><td style="color:rgb(0, 0, 0);word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">block.number</td><td style="color:rgb(0, 0, 0);word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">uint</td><td style="color:rgb(0, 0, 0);font-size:12pt;word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">当前区块的编号（高度）。</td></tr><tr height="143"><td style="color:rgb(0, 0, 0);word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">block.timestamp</td><td style="color:rgb(0, 0, 0);word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">uint</td><td style="color:rgb(0, 0, 0);font-size:12pt;word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">当前区块的时间戳（Unix 时间，即从1970年1月1日开始的秒数）。</td></tr><tr height="53"><td style="color:rgb(0, 0, 0);word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">block.difficulty</td><td style="color:rgb(0, 0, 0);word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">uint</td><td style="color:rgb(0, 0, 0);font-size:12pt;word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">当前区块的难度。</td></tr><tr height="53"><td style="color:rgb(0, 0, 0);word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">block.coinbase</td><td style="color:rgb(0, 0, 0);word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">address</td><td style="color:rgb(0, 0, 0);font-size:12pt;word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">当前区块矿工的地址。</td></tr><tr height="53"><td style="color:rgb(0, 0, 0);word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">block.gaslimit</td><td style="color:rgb(0, 0, 0);word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">uint</td><td style="color:rgb(0, 0, 0);font-size:12pt;word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">当前区块的 Gas 上限。</td></tr><tr height="98"><td style="color:rgb(0, 0, 0);word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">block.basefee</td><td style="color:rgb(0, 0, 0);word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">uint</td><td style="color:rgb(0, 0, 0);font-size:12pt;word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">当前区块的基础费用（在 EIP-1559 之后引入）。</td></tr><tr height="98"><td style="color:rgb(0, 0, 0);word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">block.chainid</td><td style="color:rgb(0, 0, 0);word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">uint</td><td style="color:rgb(0, 0, 0);font-size:12pt;word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">当前链的 ID（在多链环境中有用）。</td></tr></tbody></table></byte-sheet-html-origin>

#### 示例：

```Solidity
// SPDX-License-Identifier: MITpragma solidity ^0.8.0;contract BlockInfo {    function getBlockInfo() public view returns (uint256, uint256, address) {        return (block.number, block.timestamp, block.coinbase);    }}
```

在这个例子中，`getBlockInfo` 返回当前区块的编号、时间戳和矿工的地址。

2. 交易相关的全局变量
  

这些全局变量提供与当前交易相关的信息。
<style><!--br {mso-data-placement:same-cell;}--> td {white-space:nowrap;border:1px solid #dee0e3;font-size:10pt;font-style:normal;font-weight:normal;vertical-align:middle;word-break:normal;word-wrap:normal;}</style><byte-sheet-html-origin data-id="" data-version="4" data-is-embed="true" data-grid-line-hidden="false" data-copy-type="col"><table style="border-collapse: collapse;"><colgroup><col width="105"><col width="105"><col width="105"></colgroup><tbody><tr height="31"><td style="color:rgb(0, 0, 0);font-size:12pt;font-weight:bold;text-align:center;word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">全局变量</td><td style="color:rgb(0, 0, 0);font-size:12pt;font-weight:bold;text-align:center;word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">类型</td><td style="color:rgb(0, 0, 0);font-size:12pt;font-weight:bold;text-align:center;word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">描述</td></tr><tr height="98"><td style="color:rgb(0, 0, 0);word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">tx.gasprice</td><td style="color:rgb(0, 0, 0);word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">uint</td><td style="color:rgb(0, 0, 0);font-size:12pt;word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">当前交易的 Gas 价格（每单位 Gas 的价格）。</td></tr><tr height="121"><td style="color:rgb(0, 0, 0);word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">tx.origin</td><td style="color:rgb(0, 0, 0);word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">address</td><td style="color:rgb(0, 0, 0);font-size:12pt;word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">交易的发起者（最初的外部账户，不包括合约调用者）。</td></tr></tbody></table></byte-sheet-html-origin>

#### 示例：

```Solidity
// SPDX-License-Identifier: MITpragma solidity ^0.8.0;contract TransactionInfo {    function getTransactionInfo() public view returns (uint256, address) {        return (tx.gasprice, tx.origin);    }}
```

在这个例子中，`getTransactionInfo` 返回当前交易的 Gas 价格和交易的最初发起者（注意，这与 `msg.sender` 不同）。

3. 消息相关的全局变量
  

这些全局变量提供与当前消息调用相关的信息。
<style><!--br {mso-data-placement:same-cell;}--> td {white-space:nowrap;border:1px solid #dee0e3;font-size:10pt;font-style:normal;font-weight:normal;vertical-align:middle;word-break:normal;word-wrap:normal;}</style><byte-sheet-html-origin data-id="" data-version="4" data-is-embed="true" data-grid-line-hidden="false" data-copy-type="col"><table style="border-collapse: collapse;"><colgroup><col width="105"><col width="105"><col width="105"></colgroup><tbody><tr height="31"><td style="color:rgb(0, 0, 0);font-size:12pt;font-weight:bold;text-align:center;word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">全局变量</td><td style="color:rgb(0, 0, 0);font-size:12pt;font-weight:bold;text-align:center;word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">类型</td><td style="color:rgb(0, 0, 0);font-size:12pt;font-weight:bold;text-align:center;word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">描述</td></tr><tr height="98"><td style="color:rgb(0, 0, 0);word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">msg.sender</td><td style="color:rgb(0, 0, 0);word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">address</td><td style="color:rgb(0, 0, 0);font-size:12pt;word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">调用合约的账户（外部账户或合约地址）。</td></tr><tr height="98"><td style="color:rgb(0, 0, 0);word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">msg.value</td><td style="color:rgb(0, 0, 0);word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">uint</td><td style="color:rgb(0, 0, 0);font-size:12pt;word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">调用合约时发送的以太坊数量（单位：wei）。</td></tr><tr height="98"><td style="color:rgb(0, 0, 0);word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">msg.data</td><td style="color:rgb(0, 0, 0);word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">bytes</td><td style="color:rgb(0, 0, 0);font-size:12pt;word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">调用合约时传递的数据（不包括函数签名）。</td></tr><tr height="121"><td style="color:rgb(0, 0, 0);word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">msg.sig</td><td style="color:rgb(0, 0, 0);word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">bytes4</td><td style="color:rgb(0, 0, 0);font-size:12pt;word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">调用合约的函数选择器（即函数签名的前 4 字节）。</td></tr><tr height="121"><td style="color:rgb(0, 0, 0);word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">msg.gas</td><td style="color:rgb(0, 0, 0);word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">uint</td><td style="color:rgb(0, 0, 0);font-size:12pt;word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">剩余的 Gas（Solidity 0.4.x 及以下版本中可用，已被弃用）。</td></tr></tbody></table></byte-sheet-html-origin>

#### 示例：

```Solidity
// SPDX-License-Identifier: MITpragma solidity ^0.8.0;contract MessageInfo {    function getMessageInfo() public payable returns (address, uint256, bytes memory, bytes4) {        return (msg.sender, msg.value, msg.data, msg.sig);    }}
```

在这个例子中，`getMessageInfo` 返回调用者的地址（即 `msg.sender`）、发送的以太币数量（`msg.value`）、调用时传递的数据（`msg.data`），以及函数选择器（`msg.sig`）。

### 4. `abi` 和 `blockhash`

- **`abi.encode(...)`** **和** **`abi.decode(...)`**：用于对数据进行编码和解码。
  

```Solidity
bytes memory encodedData = abi.encode("Hello", uint256(100));
```

- **`blockhash(uint blockNumber)`**：返回指定区块号的区块哈希（仅限于最近的 256 个区块）。
  

```Solidity
bytes32 blockHash = blockhash(block.number - 1);
```

### 全局变量的应用场景

1. **获取当前区块的信息**：例如，验证智能合约中的事件是否在某个特定区块之后发生，或者设定某个操作需要在未来的某个区块执行。
  

```Solidity
function checkBlockTime() public view returns (bool) {    // 判断当前时间是否在未来的某个时间点前    return block.timestamp > 172800; // Unix 时间戳 172800 为 2 天后}
```

2. **限制合约调用者**：通过 `msg.sender` 验证调用者身份，确保某些操作只能由特定地址执行。
  

```Solidity
address public owner;constructor() {    owner = msg.sender; // 部署者为合约的所有者}function restrictedFunction() public view {    require(msg.sender == owner, "Only the owner can call this function");    // 执行某些操作}
```

3. **处理以太币转账**：通过 `msg.value` 获取发往合约的以太币，并使用该值进行计算或保存。
  

```Solidity
function deposit() public payable {    require(msg.value > 0, "Must send some ether");    // 处理接收到的以太币}
```

4. **获取交易信息**：使用 `tx.origin` 验证交易的最初发起者，虽然通常不推荐依赖它（因为它可能会导致安全性问题，比如被中间合约劫持）。
  

```Solidity
function checkOrigin() public view returns (bool) {    return tx.origin == msg.sender; // 比较最初的发起者和直接的调用者}
```

### 注意事项

- **`tx.origin`** **的安全问题**：`tx.origin` 返回的是交易的最初发起者地址，而不是当前调用者（即 `msg.sender`）。在多次合约调用时，`tx.origin` 始终指向原始的外部账户，这可能会被中间合约利用，进行恶意操作。因此，通常建议使用 `msg.sender` 而不是 `tx.origin`。
  
- **Gas 消耗**：虽然读取全局变量不会直接增加大量 **Gas**，但是某些操作（例如获取区块哈希或使用 `block.number` 进行复杂的逻辑计算）可能会导致合约的 Gas 消耗增加。因此，开发智能合约时，应该尽量避免不必要的全局变量读取。
  

### 总结

- **全局变量** 是 Solidity 提供的内建变量，允许开发者访问区块链的上下文信息，如当前区块的时间戳、交易发起者、发送的以太币数量等。
  
- 全局变量不需要显式声明，开发者可以在函数内部直接使用它们。
  
- 常用的全局变量包括：`msg.sender`（消息发送者）、`msg.value`（发送的以太币数量）、`block.timestamp`（区块时间戳）、`tx.origin`（交易的起始发起者）等。
  
- 虽然全局变量在智能合约开发中非常有用，但在使用某些全局变量时（例如 `tx.origin`），要特别注意安全性和最佳实践，以避免潜在的安全漏洞。