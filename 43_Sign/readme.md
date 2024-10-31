# Solidity 验证签名 (Verify Signature)

在 Solidity 中，签名验证是一种非常常见的操作，通常用于验证某个消息是否由特定的地址签署。这对于验证用户身份、授权操作等场景非常有用。

### 签名验证流程

签名验证流程通常由以下步骤组成：

1. **消息哈希** ：将待签名的消息进行哈希处理。
2. **签名生成** ：使用签名者的私钥对消息哈希进行签名，生成签名值（通常在链下完成）。
3. **签名验证** ：在链上使用 `ecrecover` 函数从签名中恢复出签名者的地址，并与预期的地址进行比较。

`ecrecover` 函数允许你从签名中恢复出签名者的地址。如果恢复的地址与预期的地址一致，则说明签名有效。

### 重要函数

* **`ecrecover`** ：这是 Solidity 内置的函数，接收消息的哈希值、签名的 `v`, `r`, `s` 部分，然后返回签名者的地址。

### 示例：验证签名

我们将展示如何在 Solidity 中验证签名。流程如下：

1. 生成消息的哈希值。
2. 使用私钥对该哈希进行签名，得到 `v`, `r`, `s`。
3. 使用 `ecrecover` 恢复出签名者的地址，并验证其是否为预期的地址。
4. 创建消息的哈希

在以太坊中，签名时通常需要对消息进行哈希处理，并对该哈希进行签名。为了确保消息不可被重用，哈希时通常包含前缀 `"\x19Ethereum Signed Message:\n32"`，这是以太坊签名消息的标准格式。

```Solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
contract SignatureVerifier {
    // 将消息哈希为符合以太坊签名格式的哈希
    function getMessageHash(string memory message) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(message));
    }
    // 返回以太坊签名消息的格式化哈希
    function getEthSignedMessageHash(bytes32 messageHash) public pure returns (bytes32) {
        return keccak256(
            abi.encodePacked("\x19Ethereum Signed Message:\n32", messageHash)
        );
    }
    // 使用 ecrecover 验证签名是否有效
    function verifySignature(
        string memory message,
        uint8 v,
        bytes32 r,
        bytes32 s,
        address expectedSigner
    ) public pure returns (bool) {
        // 1. 获取消息哈希
        bytes32 messageHash = getMessageHash(message);
        // 2. 获取以太坊签名消息格式的哈希
        bytes32 ethSignedMessageHash = getEthSignedMessageHash(messageHash);
        // 3. 使用 ecrecover 恢复签名者的地址
        address signer = ecrecover(ethSignedMessageHash, v, r, s);
        // 4. 检查恢复的地址是否与预期的签名者地址一致
        return (signer == expectedSigner);
    }
}
```

### 代码详解：

1. **`getMessageHash`** ：
   1. 输入一个字符串 `message`，生成该字符串的 Keccak256 哈希值。
2. **`getEthSignedMessageHash`** ：
   1. 输入消息的哈希值，并返回带有以太坊标准前缀的哈希值。这个前缀是 `"\x19Ethereum Signed Message:\n32"`，目的是防止签名者对相同的消息在不同上下文中重复使用。
3. **`verifySignature`** ：
   1. 输入原始消息、签名的 `v`, `r`, `s` 参数，以及预期的签名者地址。
   2. 通过 `getMessageHash` 生成消息哈希，然后生成符合以太坊签名格式的消息哈希。
   3. 使用 `ecrecover` 从签名中恢复出签名者的地址。
   4. 比较恢复出的地址与预期的签名者地址是否一致。如果一致，则签名验证通过。

### 签名生成流程（链下操作）

签名过程通常在链下完成，签名者使用自己的私钥对消息进行签名。以下是使用 Web3.js 生成签名的示例流程：

#### 使用 Web3.js 生成签名

```JavaScript
const Web3 = require('web3');
const web3 = new Web3('https://mainnet.infura.io/v3/YOUR_INFURA_PROJECT_ID');
// 1. 创建消息
const message = "Hello, Ethereum!";
const messageHash = web3.utils.keccak256(message);
// 2. 获取带有以太坊签名格式的哈希
const ethSignedMessageHash = web3.eth.accounts.hashMessage(message);
// 3. 使用私钥签名消息哈希
const privateKey = "0x...";  // 签名者的私钥
const signature = web3.eth.accounts.sign(message, privateKey);
console.log("Message hash:", messageHash);
console.log("Eth signed message hash:", ethSignedMessageHash);
console.log("Signature:", signature);
```

#### Web3.js 签名返回值结构

* `signature.signature`：包含生成的签名，它是一个 65 字节的字符串，包含 `r`, `s`, `v` 三个部分。
* 你可以将签名的 `r`, `s`, `v` 部分传递给 Solidity 合约中的 `verifySignature` 方法。

### 签名验证流程（链上操作）

1. **链下生成签名** ：签名者使用私钥对消息进行签名，生成 `v`, `r`, `s`。
2. **链上验证签名** ：将消息、签名的 `v`, `r`, `s`，以及预期的签名者地址传递到智能合约中的 `verifySignature` 函数进行验证。

### 示例：完整测试流程

1. 假设消息是 `"Hello, Ethereum!"`。
2. 签名者链下使用私钥对该消息生成签名。
3. 部署 `SignatureVerifier` 合约。
4. 调用 `verifySignature` 函数，传递消息、签名的 `v`, `r`, `s` 参数，以及预期的签名者地址。
5. 如果返回 `true`，则签名验证成功。

### 示例签名数据

假设使用以下数据进行签名：

* **消息** ：`"Hello, Ethereum!"`
* **签名者地址** ：`0x1234...`
* **签名的 ** **`r`** **, ** **`s`** **, ** **`v`** ：

```Plain
v = 28
r = 0x6c3699283bda56a56b31e0d4b3c7ed5b84b1fd6e5e7f6d1d8b13aab21b9d1a3c
s = 0x4d2c6dfc5e762f5b4a6e2b9b1a2d9a3ed5f1f6e4c9d2c7d4b3d5e2c5f7d1c9a4
```

然后你可以调用 `verifySignature` 函数，传递这些参数来验证签名的有效性。

### 注意事项

* **消息格式** ：确保消息哈希的生成方式与链下签名时的方式一致。通常需要使用 `"Ethereum Signed Message"` 前缀来生成哈希。
* **签名的 ** **`v`** **, ** **`r`** **, ** **`s`** ：签名通常会返回这三个值，其中 `v` 是恢复 ID，`r` 和 `s` 是椭圆曲线签名的两个部分。

### 总结

* **签名验证** ：通过 `keccak256` 生成消息的哈希，并使用 `ecrecover` 从签名中恢复出签名者的地址。验证签名者的地址是否与预期的地址一致。
* **`ecrecover`** ：是 Solidity 中恢复签名者地址的核心函数。它接受消息哈希和签名的 `v`, `r`, `s` 参数。
* **链下签名** ：通常使用工具（如 Web3.js）进行签名，然后将签名的 `v`, `r`, `s` 参数传递给智能合约进行验证。

通过这种机制，可以在智能合约中实现用户授权、签名验证等功能，确保数据的真实性和完整性
