# Solidity ERC20 (ERC20)

在 Solidity 中，**ERC-20** 是最常用的代币标准之一。ERC-20 代币标准定义了一套统一的接口，允许代币在不同的 DApps 和交易所之间进行互操作。一个符合 ERC-20 标准的代币合约需要实现一些必要的功能，如代币的转账、查询余额、授权转账等。

### ERC-20 标准函数

根据 ERC-20 标准，代币合约需要实现以下函数：

1. **`totalSupply`** ：返回代币的总供应量。
2. **`balanceOf`** ：返回指定地址的代币余额。
3. **`transfer`** ：从调用者的账户向某个地址转移一定数量的代币。
4. **`transferFrom`** ：从授权的账户中向另一个地址转移代币。
5. **`approve`** ：允许某个地址从调用者的账户中转移代币。
6. **`allowance`** ：返回某个账户可以使用的代币金额（基于 `approve` 授权）。

### ERC-20 标准事件

ERC-20 标准还定义了两个事件：

1. **`Transfer`** ：当代币从一个地址转移到另一个地址时触发。
2. **`Approval`** ：当某个地址被授权可以花费一定数量的代币时触发。

### OpenZeppelin 的 ERC-20 实现

为了简化开发，可以直接使用 OpenZeppelin 提供的安全且经过广泛审计的 ERC-20 实现。我们可以继承 OpenZeppelin 的 ERC-20 合约并扩展其功能。

### 示例：使用 OpenZeppelin 实现 ERC-20 代币

首先，确保你安装了 OpenZeppelin 合约库：

```Bash
npm install @openzeppelin/contracts
```

然后，编写合约代码：

```Solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
contract MyToken is ERC20 {
    // 构造函数，初始化代币的名称、符号以及发行总量
    constructor(uint256 initialSupply) ERC20("MyToken", "MTK") {
        // 铸造 initialSupply 数量的代币，并将其分配给合约创建者
        _mint(msg.sender, initialSupply);
    }
}
```

### 说明：

1. **`ERC20("MyToken", "MTK")`** ：继承 OpenZeppelin 的 `ERC20` 合约，并为代币指定名称为 `MyToken`，符号为 `MTK`。
2. **`_mint(msg.sender, initialSupply)`** ：在合约部署时铸造 `initialSupply` 数量的代币，并将其分配给合约部署者（`msg.sender`）。

### 编译和部署

你可以使用 Truffle 或 Hardhat 等工具来编译和部署该合约。在此以 Hardhat 为例：

1. **编译合约** ：

```Bash
npx hardhat compile
```

2. **部署脚本** （部署时指定初始供应量）：

```JavaScript
const hre = require("hardhat");
async function main() {
  const [deployer] = await hre.ethers.getSigners();
  const MyToken = await hre.ethers.getContractFactory("MyToken");
  const initialSupply = hre.ethers.utils.parseUnits("10000", 18); // 10000 tokens with 18 decimals
  const token = await MyToken.deploy(initialSupply);
  await token.deployed();
  console.log("MyToken deployed to:", token.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
```

3. **部署合约** ：

```Bash
npx hardhat run scripts/deploy.js --network <network>
```

### ERC-20 常用功能说明

#### 1. `transfer` 函数

```Solidity
function transfer(address recipient, uint256 amount) public returns (bool);
```

* **功能** ：从调用者的账户向 `recipient` 地址转移 `amount` 数量的代币。
* **示例** ：

```Solidity
token.transfer(0xRecipientAddress, 1000);
```

#### 2. `approve` 和 `transferFrom` 函数

* **`approve`** ：允许某个地址在调用者的账户中最多可以花费 `amount` 数量的代币。

```Solidity
function approve(address spender, uint256 amount) public returns (bool);
```

* **`transferFrom`** ：从授权的 `from` 地址向 `to` 地址转移 `amount` 数量的代币。

```Solidity
function transferFrom(address from, address to, uint256 amount) public returns (bool);
```

* **示例** ：

```Solidity
token.approve(0xSpenderAddress, 500);
token.transferFrom(0xSenderAddress, 0xRecipientAddress, 500);
```

#### 3. `allowance` 函数

```Solidity
function allowance(address owner, address spender) public view returns (uint256);
```

* **功能** ：返回 `spender` 地址被授权可以从 `owner` 账户中转移的代币数量。
* **示例** ：

```Solidity
uint256 remaining = token.allowance(0xOwnerAddress, 0xSpenderAddress);
```

### 编写测试用例

你可以使用 Hardhat 或 Truffle 来编写测试用例。以下是基于 Hardhat 的测试代码示例。

#### 测试案例

```JavaScript
const { expect } = require("chai");
describe("MyToken", function () {
  let MyToken, myToken, owner, addr1, addr2;
  beforeEach(async function () {
    MyToken = await ethers.getContractFactory("MyToken");
    [owner, addr1, addr2] = await ethers.getSigners();
    const initialSupply = ethers.utils.parseUnits("10000", 18); // 10000 tokens
    myToken = await MyToken.deploy(initialSupply);
    await myToken.deployed();
  });

  it("should assign the total supply of tokens to the owner", async function () {
    const ownerBalance = await myToken.balanceOf(owner.address);
    expect(await myToken.totalSupply()).to.equal(ownerBalance);
  });

  it("should transfer tokens between accounts", async function () {
    // Transfer 1000 tokens from owner to addr1
    await myToken.transfer(addr1.address, ethers.utils.parseUnits("1000", 18));
    const addr1Balance = await myToken.balanceOf(addr1.address);
    expect(addr1Balance).to.equal(ethers.utils.parseUnits("1000", 18));
  });

  it("should fail if sender doesn’t have enough tokens", async function () {
    const initialOwnerBalance = await myToken.balanceOf(owner.address);
    // Try to send 1 token from addr1 (0 tokens) to owner.
    await expect(
      myToken.connect(addr1).transfer(owner.address, ethers.utils.parseUnits("1", 18))
    ).to.be.revertedWith("ERC20: transfer amount exceeds balance");
    // Owner balance shouldn't have changed.
    expect(await myToken.balanceOf(owner.address)).to.equal(initialOwnerBalance);
  });

  it("should update balances after transfers", async function () {
    const initialOwnerBalance = await myToken.balanceOf(owner.address);
    // Transfer 1000 tokens from owner to addr1.
    await myToken.transfer(addr1.address, ethers.utils.parseUnits("1000", 18));
    // Transfer 500 tokens from addr1 to addr2.
    await myToken.connect(addr1).transfer(addr2.address, ethers.utils.parseUnits("500", 18));
    const finalOwnerBalance = await myToken.balanceOf(owner.address);
    expect(finalOwnerBalance).to.equal(initialOwnerBalance.sub(ethers.utils.parseUnits("1000", 18)));
    const addr1Balance = await myToken.balanceOf(addr1.address);
    expect(addr1Balance).to.equal(ethers.utils.parseUnits("500", 18));
    const addr2Balance = await myToken.balanceOf(addr2.address);
    expect(addr2Balance).to.equal(ethers.utils.parseUnits("500", 18));
  });

  it("should allow accounts to approve and transferFrom", async function () {
    // Owner approves addr1 to spend 500 tokens on their behalf
    await myToken.approve(addr1.address, ethers.utils.parseUnits("500", 18));
    expect(await myToken.allowance(owner.address, addr1.address)).to.equal(ethers.utils.parseUnits("500", 18));
    // addr1 transfers 400 tokens from owner to addr2
    await myToken.connect(addr1).transferFrom(owner.address, addr2.address, ethers.utils.parseUnits("400", 18));
    const addr2Balance = await myToken.balanceOf(addr2.address);
    expect(addr2Balance).to.equal(ethers.utils.parseUnits("400", 18));
    const remainingAllowance = await myToken.allowance(owner.address, addr1.address);
    expect(remainingAllowance).to.equal(ethers.utils.parseUnits("100", 18)); // 500 - 400 = 100
  });
});
```

### 测试说明

1. **测试代币分配** ：确保初始供应量分配给了合约部署者。
2. **测试代币转账** ：测试代币从一个账户转移到另一个账户，确保余额正确更新。
3. **测试余额不足时的转账失败** ：确保当转账金额超过余额时，交易会失败。
4. **测试 ****`approve`**** 和 ** **`transferFrom`** ：测试授权机制，确保 `transferFrom` 可以转移授权的代币，并正确更新授权额度。

### 运行测试

使用以下命令运行测试：

```JavaScript
npx hardhat test
```

### 总结

* 我们创建了一个符合 ERC-20 标准的代币合约，并使用 OpenZeppelin 提供的库简化开发。
* 通过使用 Hardhat，我们编写并运行了测试，确保代币的转账和授权机制正常工作。
* ERC-20 标准为代币的互操作性提供了基础，广泛应用于以太坊生态系统中的代币发行和交易。
