在 Solidity 中，函数有不同的修饰符，用于指示它们是否可以读取或修改合约的状态。主要有两种函数修饰符：**视图（****`view`****）函数** 和 **纯（****`pure`****）函数**。它们的主要区别在于是否允许读取状态变量或使用全局变量。

### 1. `view`（视图）函数

**`view`** **函数** 声明该函数**只能读取**状态变量或全局变量，**不能修改**它们。该修饰符通常用于获取合约的状态，而不改变任何状态。

#### 特点：

- `view` 函数可以读取状态变量和全局变量（如 `block.number`、`msg.sender` 等）。
  
- 它不允许修改状态变量、发送交易或改变区块链的状态。
  
- 虽然 `view` 函数不能修改状态，但它仍然**可以读取**状态变量。
  
- 调用 `view` 函数不会消耗 **Gas**，**除非**它是在交易中调用的（而不是在外部读取的）。
  

#### 示例：

```Solidity
// SPDX-License-Identifier: MITpragma solidity ^0.8.0;contract ViewExample {    uint256 public stateVar = 100;    // 视图函数：可以读取状态变量，但不能修改    function getStateVar() public view returns (uint256) {        return stateVar;  // 读取状态变量    }    // 视图函数：可以读取全局变量    function getBlockNumber() public view returns (uint256) {        return block.number;  // 读取全局变量    }}
```

在上述代码中：

- `getStateVar` 函数读取了合约中的状态变量 `stateVar`。
  
- `getBlockNumber` 函数读取了全局变量 `block.number`，它提供当前区块的编号。
  

### 2. `pure`（纯）函数

**`pure`** **函数** 声明该函数既**不能读取**也**不能修改**合约的状态。纯函数完全独立于合约的状态，只依赖于输入参数和局部变量。

#### 特点：

- `pure` 函数不能读取或修改状态变量。
  
- 它也不能访问任何全局变量（如 `block.number`、`msg.sender`、`tx.origin` 等）。
  
- 纯函数只能使用局部变量或传入的参数进行计算。
  
- 调用 `pure` 函数不会消耗 **Gas**，**除非**它是在交易中调用的。
  

#### 示例：

```Solidity
// SPDX-License-Identifier: MITpragma solidity ^0.8.0;contract PureExample {    // 纯函数：不能读取状态变量或全局变量，只能依赖输入参数    function add(uint256 a, uint256 b) public pure returns (uint256) {        return a + b;  // 仅依赖输入参数    }    // 纯函数：不能访问全局变量或状态变量    function multiply(uint256 a, uint256 b) public pure returns (uint256) {        return a * b;    }}
```

在上述代码中：

- `add` 和 `multiply` 函数都是纯函数，它们只依赖输入参数 `a` 和 `b`，不依赖合约的任何状态或全局变量。
  

### 3. `view` 和 `pure` 的区别

<style><!--br {mso-data-placement:same-cell;}--> td {white-space:nowrap;border:1px solid #dee0e3;font-size:10pt;font-style:normal;font-weight:normal;vertical-align:middle;word-break:normal;word-wrap:normal;}</style><byte-sheet-html-origin data-id="" data-version="4" data-is-embed="true" data-grid-line-hidden="false" data-copy-type="col"><table style="border-collapse: collapse;"><colgroup><col width="105"><col width="105"><col width="105"></colgroup><tbody><tr height="31"><td style="color:rgb(0, 0, 0);font-size:12pt;font-weight:bold;text-align:center;word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">特性</td><td data-sheet-value="[{&quot;type&quot;:&quot;text&quot;,&quot;text&quot;:&quot;view&quot;,&quot;style&quot;:{&quot;font&quot;:&quot;bold 10pt/1.5 MonospacedNumber, LarkHackSafariFont, LarkEmojiFont, LarkChineseQuote, -apple-system, BlinkMacSystemFont, \&quot;Helvetica Neue\&quot;, Tahoma, \&quot;PingFang SC\&quot;, \&quot;Microsoft Yahei\&quot;, Arial, \&quot;Hiragino Sans GB\&quot;, sans-serif, \&quot;Apple Color Emoji\&quot;, \&quot;Segoe UI Emoji\&quot;, \&quot;Segoe UI Symbol\&quot;, \&quot;Noto Color Emoji\&quot;&quot;,&quot;foreColor&quot;:&quot;rgb(0, 0, 0)&quot;}},{&quot;type&quot;:&quot;text&quot;,&quot;text&quot;:&quot; 函数&quot;}]" style="color:rgb(0, 0, 0);font-size:12pt;font-weight:bold;text-align:center;word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">view 函数</td><td data-sheet-value="[{&quot;type&quot;:&quot;text&quot;,&quot;text&quot;:&quot;pure&quot;,&quot;style&quot;:{&quot;font&quot;:&quot;bold 10pt/1.5 MonospacedNumber, LarkHackSafariFont, LarkEmojiFont, LarkChineseQuote, -apple-system, BlinkMacSystemFont, \&quot;Helvetica Neue\&quot;, Tahoma, \&quot;PingFang SC\&quot;, \&quot;Microsoft Yahei\&quot;, Arial, \&quot;Hiragino Sans GB\&quot;, sans-serif, \&quot;Apple Color Emoji\&quot;, \&quot;Segoe UI Emoji\&quot;, \&quot;Segoe UI Symbol\&quot;, \&quot;Noto Color Emoji\&quot;&quot;,&quot;foreColor&quot;:&quot;rgb(0, 0, 0)&quot;}},{&quot;type&quot;:&quot;text&quot;,&quot;text&quot;:&quot; 函数&quot;}]" style="color:rgb(0, 0, 0);font-size:12pt;font-weight:bold;text-align:center;word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">pure 函数</td></tr><tr height="31"><td style="color:rgb(0, 0, 0);font-size:12pt;font-weight:bold;word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">读取状态变量</td><td style="color:rgb(0, 0, 0);font-size:12pt;word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">允许</td><td style="color:rgb(0, 0, 0);font-size:12pt;word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">不允许</td></tr><tr height="31"><td style="color:rgb(0, 0, 0);font-size:12pt;font-weight:bold;word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">修改状态变量</td><td style="color:rgb(0, 0, 0);font-size:12pt;word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">不允许</td><td style="color:rgb(0, 0, 0);font-size:12pt;word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">不允许</td></tr><tr height="76"><td style="color:rgb(0, 0, 0);font-size:12pt;font-weight:bold;word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">使用全局变量</td><td data-sheet-value="[{&quot;type&quot;:&quot;text&quot;,&quot;text&quot;:&quot;允许（如 &quot;},{&quot;type&quot;:&quot;text&quot;,&quot;text&quot;:&quot;block.number&quot;,&quot;style&quot;:{&quot;font&quot;:&quot;10pt/1.5 MonospacedNumber, LarkHackSafariFont, LarkEmojiFont, LarkChineseQuote, -apple-system, BlinkMacSystemFont, \&quot;Helvetica Neue\&quot;, Tahoma, \&quot;PingFang SC\&quot;, \&quot;Microsoft Yahei\&quot;, Arial, \&quot;Hiragino Sans GB\&quot;, sans-serif, \&quot;Apple Color Emoji\&quot;, \&quot;Segoe UI Emoji\&quot;, \&quot;Segoe UI Symbol\&quot;, \&quot;Noto Color Emoji\&quot;&quot;,&quot;foreColor&quot;:&quot;rgb(0, 0, 0)&quot;}},{&quot;type&quot;:&quot;text&quot;,&quot;text&quot;:&quot;、&quot;},{&quot;type&quot;:&quot;text&quot;,&quot;text&quot;:&quot;msg.sender&quot;,&quot;style&quot;:{&quot;font&quot;:&quot;10pt/1.5 MonospacedNumber, LarkHackSafariFont, LarkEmojiFont, LarkChineseQuote, -apple-system, BlinkMacSystemFont, \&quot;Helvetica Neue\&quot;, Tahoma, \&quot;PingFang SC\&quot;, \&quot;Microsoft Yahei\&quot;, Arial, \&quot;Hiragino Sans GB\&quot;, sans-serif, \&quot;Apple Color Emoji\&quot;, \&quot;Segoe UI Emoji\&quot;, \&quot;Segoe UI Symbol\&quot;, \&quot;Noto Color Emoji\&quot;&quot;,&quot;foreColor&quot;:&quot;rgb(0, 0, 0)&quot;}},{&quot;type&quot;:&quot;text&quot;,&quot;text&quot;:&quot;）&quot;}]" style="color:rgb(0, 0, 0);font-size:12pt;word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">允许（如 block.number、msg.sender）</td><td style="color:rgb(0, 0, 0);font-size:12pt;word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">不允许</td></tr><tr height="53"><td style="color:rgb(0, 0, 0);font-size:12pt;font-weight:bold;word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">依赖状态变量或环境</td><td style="color:rgb(0, 0, 0);font-size:12pt;word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">允许</td><td style="color:rgb(0, 0, 0);font-size:12pt;word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">不允许</td></tr><tr height="98"><td style="color:rgb(0, 0, 0);font-size:12pt;font-weight:bold;word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">Gas 消耗</td><td style="color:rgb(0, 0, 0);font-size:12pt;word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">在外部调用时不消耗 Gas，交易中调用时可能消耗</td><td style="color:rgb(0, 0, 0);font-size:12pt;word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">在外部调用时不消耗 Gas，交易中调用时可能消耗</td></tr><tr height="76"><td style="color:rgb(0, 0, 0);font-size:12pt;font-weight:bold;word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">适用场景</td><td style="color:rgb(0, 0, 0);font-size:12pt;word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">读取状态或全局变量时使用</td><td style="color:rgb(0, 0, 0);font-size:12pt;word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">纯粹依赖输入参数进行计算时使用</td></tr></tbody></table></byte-sheet-html-origin>

1. 实际使用场景
  

#### `view` 函数的使用场景：

- **读取合约的状态**：例如获取用户的余额、合约的总供应量等信息。
  
- **检查区块链状态**：例如获取当前区块号、当前时间戳、消息发送者等全局信息。
  

```Solidity
// SPDX-License-Identifier: MITpragma solidity ^0.8.0;contract BalanceChecker {    mapping(address => uint256) public balances;    // 视图函数：可以读取状态变量    function getBalance(address user) public view returns (uint256) {        return balances[user];    }}
```

#### `pure` 函数的使用场景：

- **计算函数**：仅依赖输入参数进行计算的函数，例如数学运算。
  
- **辅助工具函数**：例如字符串处理、数组操作等不依赖状态的函数。
  

```Solidity
// SPDX-License-Identifier: MITpragma solidity ^0.8.0;contract MathOperations {    // 纯函数：仅依赖输入参数进行运算    function square(uint256 x) public pure returns (uint256) {        return x * x;    }    // 纯函数：计算乘法    function multiply(uint256 a, uint256 b) public pure returns (uint256) {        return a * b;    }}
```

2. 注意事项
  

- 调用 `view` 或 `pure` 函数时，如果是**链下调用**（例如通过以太坊节点的 `eth_call`），不会消耗 Gas；
  
- 但是，如果在交易中调用 `view` 或 `pure` 函数（例如通过合约内部调用），依然会消耗 Gas，因为执行合约本身就需要消耗 Gas。
  

### 总结

- **`view`** **函数**：允许读取状态变量和全局变量，但不能修改它们。适用于获取合约状态或区块链环境信息的场景。
  
- **`pure`** **函数**：既不读取也不修改状态变量，只依赖输入参数。适用于纯计算的场景。