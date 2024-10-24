# Solidity 发送以太币 (Send ETH)

在 Solidity 中，发送以太币（ETH）有三种常用的方式：`transfer`、`send` 和 `call`。每种方式都有其特点和用法，开发者需要根据不同的场景选择合适的方式来发送以太币。

### 1. **`transfer`**

`transfer` 是一种简单、安全的发送以太币的方式。如果发送失败，交易会自动回滚。它还具有 2300 Gas 限制，因此在接收方无法执行复杂逻辑的情况下表现稳定。

#### 用法：

```Solidity
payable(address).transfer(amount);
```

- **`address`**：接收以太币的地址，必须是 `payable` 类型。
  
- **`amount`**：发送的以太币数量，以 wei 为单位。
  

#### 特点：

- 自动回滚：如果发送失败，交易会自动回滚。
  
- 固定的 Gas 限制：`transfer` 只提供 2300 Gas，足以让接收方执行简单的操作（比如记录接收的以太币）。
  
- 安全性好：防止了某些类型的重入攻击，但由于 Gas 限制，可能在某些情况下无法使用。
  

#### 示例：

```Solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TransferExample {
    // 收款地址
    address payable public recipient;

    constructor(address payable _recipient) {
        recipient = _recipient;
    }

    // 使用 transfer 发送以太币
    function sendViaTransfer() public payable {
        recipient.transfer(msg.value);
    }

    // 获取合约余额
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}
```

### 2. **`send`**

`send` 方式与 `transfer` 类似，但它返回一个布尔值，表示交易是否成功。与 `transfer` 相比，`send` 不会自动回滚交易，开发者需要手动检查返回值，并在发送失败时执行相应的操作。

#### 用法：

```Solidity
bool success = payable(address).send(amount);
```

- **`address`**：接收以太币的地址，必须是 `payable` 类型。
  
- **`amount`**：发送的以太币数量，以 wei 为单位。
  
- **`success`**：返回布尔值，表示发送是否成功。
  

#### 特点：

- 需要手动处理失败：如果 `send` 返回 `false`，开发者必须手动处理失败情况。
  
- 2300 Gas 限制：与 `transfer` 一样，只提供 2300 Gas。
  
- 自动回滚：不会自动回滚，需要检查返回值并进行适当的处理。
  

#### 示例：

```Solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SendExample {
    // 收款地址
    address payable public recipient;

    constructor(address payable _recipient) {
        recipient = _recipient;
    }

    // 使用 send 发送以太币
    function sendViaSend() public payable {
        bool success = recipient.send(msg.value);
        require(success, "Failed to send Ether");
    }

    // 获取合约余额
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}
```

### 3. **`call`**

`call` 是目前推荐的发送以太币的方式，因为它没有 Gas 限制，并且能够处理复杂的情况。`call` 是一种低级别的调用方法，返回两个值：布尔值 `success` 表示调用是否成功，另一个是返回的数据。

#### 用法：

```Solidity
(bool success, ) = payable(address).call{value: amount}("");
```

- **`address`**：接收以太币的地址，必须是 `payable` 类型。
  
- **`amount`**：发送的以太币数量，以 wei 为单位。
  
- **`success`**：布尔值，表示调用是否成功。
  

#### 特点：

- 无 Gas 限制：能发送足够的 Gas，允许接收方执行复杂的逻辑。
  
- 更灵活：可以传递数据和调用其他智能合约。
  
- 手动处理失败：与 `send` 一样，需要手动检查返回值。
  

#### 示例：

```Solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CallExample {
    // 收款地址
    address payable public recipient;

    constructor(address payable _recipient) {
        recipient = _recipient;
    }

    // 使用 call 发送以太币
    function sendViaCall() public payable {
        (bool success, ) = recipient.call{value: msg.value}("");
        require(success, "Failed to send Ether");
    }

    // 获取合约余额
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}
```

### 三种方式的比较

<style><!--br {mso-data-placement:same-cell;}--> td {white-space:nowrap;border:1px solid #dee0e3;font-size:10pt;font-style:normal;font-weight:normal;vertical-align:middle;word-break:normal;word-wrap:normal;}</style><byte-sheet-html-origin data-id="" data-version="4" data-is-embed="true" data-grid-line-hidden="false" data-copy-type="col"><table style="border-collapse: collapse;"><colgroup><col width="105"><col width="105"><col width="105"><col width="105"></colgroup><tbody><tr height="31"><td style="color:rgb(0, 0, 0);font-size:12pt;font-weight:bold;text-align:center;word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">特性</td><td style="color:rgb(0, 0, 0);font-weight:bold;text-align:center;word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">transfer</td><td style="color:rgb(0, 0, 0);font-weight:bold;text-align:center;word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">send</td><td style="color:rgb(0, 0, 0);font-weight:bold;text-align:center;word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">call</td></tr><tr height="76"><td style="color:rgb(0, 0, 0);font-size:12pt;word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">返回值</td><td style="color:rgb(0, 0, 0);font-size:12pt;word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">无</td><td style="color:rgb(0, 0, 0);font-size:12pt;word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">布尔值，表示是否成功</td><td style="color:rgb(0, 0, 0);font-size:12pt;word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">布尔值，表示是否成功 + 返回的数据</td></tr><tr height="31"><td style="color:rgb(0, 0, 0);font-size:12pt;word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">Gas 限制</td><td style="color:rgb(0, 0, 0);font-size:12pt;word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">2300 Gas</td><td style="color:rgb(0, 0, 0);font-size:12pt;word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">2300 Gas</td><td style="color:rgb(0, 0, 0);font-size:12pt;word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">无限制</td></tr><tr height="53"><td style="color:rgb(0, 0, 0);font-size:12pt;word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">自动回滚</td><td style="color:rgb(0, 0, 0);font-size:12pt;word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">是</td><td style="color:rgb(0, 0, 0);font-size:12pt;word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">否，需要手动回滚</td><td style="color:rgb(0, 0, 0);font-size:12pt;word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">否，需要手动回滚</td></tr><tr height="98"><td style="color:rgb(0, 0, 0);font-size:12pt;word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">推荐场景</td><td style="color:rgb(0, 0, 0);font-size:12pt;word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">简单、安全的转账，无复杂逻辑</td><td style="color:rgb(0, 0, 0);font-size:12pt;word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">需要处理失败情况</td><td style="color:rgb(0, 0, 0);font-size:12pt;word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">更复杂的场景，允许调用其他合约或执行复杂逻辑</td></tr><tr height="53"><td style="color:rgb(0, 0, 0);font-size:12pt;word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">安全性</td><td style="color:rgb(0, 0, 0);font-size:12pt;word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">防止重入攻击</td><td style="color:rgb(0, 0, 0);font-size:12pt;word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">防止重入攻击</td><td style="color:rgb(0, 0, 0);font-size:12pt;word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">需要小心防范重入攻击</td></tr></tbody></table></byte-sheet-html-origin>

### 重入攻击问题

`transfer` 和 `send` 的 2300 Gas 限制有效地防止了重入攻击，因为攻击者无法在有限的 Gas 内执行复杂的逻辑。
当使用 `call` 时，由于没有 Gas 限制，接收方可以执行任意复杂的合约逻辑，这就可能导致重入攻击。开发者在使用 `call` 时必须特别小心，通常建议使用“检查-效果-交互”模式或引入 `ReentrancyGuard` 这样的防护机制来防止重入攻击。

### 重入攻击示例

#### 攻击合约（攻击者）

```Solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ReentranceAttack {
    address payable public victim;

    constructor(address payable _victim) {
        victim = _victim;
    }

    // 攻击函数
    function attack() public payable {
        require(msg.value >= 1 ether);
        victim.call{value: 1 ether}("");
    }

    // 回调函数，继续提取资金
    fallback() external payable {
        if (address(victim).balance >= 1 ether) {
            victim.call{value: 1 ether}("");
        }
    }
}
```

#### 防重入合约（安全的合约）

```Solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SecureContract {
    bool internal locked;

    modifier noReentrancy() {
        require(!locked, "ReentrancyGuard: reentrant call");
        locked = true;
        _;
        locked = false;
    }

    // 使用 noReentrancy 修饰符防止重入攻击
    function withdraw() public noReentrancy {
        // 提现逻辑
    }
}
```

### 总结

- `transfer`: 简单、可靠，用于发送少量 Gas 的安全交易。
  
- `send`: 需要手动处理失败的情况，不常用。
  
- `call`: 推荐用于复杂场景，但要小心防范重入攻击。