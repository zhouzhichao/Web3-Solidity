# Solidity ERC721 (ERC721)

**ERC-721** 是以太坊网络中用于实现  **不可替代代币（**  **NFT** **）** 的标准，它与 ERC-20 的区别在于，每个 ERC-721 代币都是独一无二的，不同于 ERC-20 的同质化代币。ERC-721 代币非常适合用于表示独特的资产，例如收藏品、艺术品、游戏物品等。

### ERC-721 标准必需的功能

ERC-721 标准要求实现以下核心功能：

1. **`balanceOf(address owner)`** : 查询某个地址拥有的 NFT 数量。
2. **`ownerOf(uint256 tokenId)`** : 查询某个 NFT 的所有者。
3. **`safeTransferFrom(address from, address to, uint256 tokenId)`** : 安全地将 NFT 从一个地址转移到另一个地址。
4. **`transferFrom(address from, address to, uint256 tokenId)`** : 将 NFT 从一个地址转移到另一个地址（不检查接收者是否是合约）。
5. **`approve(address to, uint256 tokenId)`** : 授权某个地址可以转移指定的 NFT。
6. **`getApproved(uint256 tokenId)`** : 查询某个 NFT 被授权给了哪个地址。
7. **`setApprovalForAll(address operator, bool approved)`** : 授权或取消授权某个操作员管理调用者的所有 NFT。
8. **`isApprovedForAll(address owner, address operator)`** : 查询某个操作员是否被授权管理某个地址的所有 NFT。

### ERC-721 标准事件

1. **`Transfer(address indexed from, address indexed to, uint256 indexed tokenId)`** ：当 NFT 被转移时触发。
2. **`Approval(address indexed owner, address indexed approved, uint256 indexed tokenId)`** ：当某个地址被授权管理特定的 NFT 时触发。
3. **`ApprovalForAll(address indexed owner, address indexed operator, bool approved)`** ：当某个地址被授权或取消授权管理持有者的所有 NFT 时触发。

### OpenZeppelin 的 ERC-721 实现

为了帮助开发者安全、快速地实现 ERC-721 合约，**OpenZeppelin** 提供了经过审计的实现。我们可以直接使用这个库来实现一个简单的 ERC-721 合约。

### 示例：使用 OpenZeppelin 实现 ERC-721 合约

首先，确保你安装了 OpenZeppelin 合约库：

```Bash
npm install @openzeppelin/contracts
```

然后，编写一个简单的 ERC-721 合约代码，该合约代表一个 NFT 收藏品：

```Solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
contract MyNFT is ERC721URIStorage, Ownable {
    uint256 private _tokenIds;
    constructor() ERC721("MyNFT", "MNFT") {}
    // 铸造新 NFT
    function mintNFT(address recipient, string memory tokenURI) public onlyOwner returns (uint256) {
        _tokenIds += 1;
        uint256 newItemId = _tokenIds;
        _mint(recipient, newItemId); // 铸造新 NFT
        _setTokenURI(newItemId, tokenURI); // 设置 Token URI
        return newItemId;
    }
}
```

### 说明：

1. **`ERC721("MyNFT", "MNFT")`** ：这个合约继承了 OpenZeppelin 的 `ERC721` 合约，并为 NFT 设置了名称为 `MyNFT`，符号为 `MNFT`。
2. **`mintNFT`** ：合约拥有者可以调用这个函数，为指定地址铸造一个新的 NFT，并设置它的 `tokenURI`（通常是指向元数据的 URL）。
3. **`ERC721URIStorage`** ：这是 OpenZeppelin 的一个扩展，它允许给每个 NFT 设定元数据的 URI。

### 编写测试用例

我们可以使用 Hardhat 或 Truffle 来编写测试用例，以下是基于 Hardhat 的测试代码示例。

#### 测试代码（Hardhat）

```JavaScript
const { expect } = require("chai");
describe("MyNFT", function () {
  let MyNFT, nft, owner, addr1, addr2;
  beforeEach(async function () {
    MyNFT = await ethers.getContractFactory("MyNFT");
    [owner, addr1, addr2] = await ethers.getSigners();
    nft = await MyNFT.deploy();
    await nft.deployed();
  });

  it("should mint and transfer an NFT", async function () {
    // 铸造第一个 NFT
    const tokenURI = "https://example.com/metadata/1";
    await nft.mintNFT(addr1.address, tokenURI);
    
    // 检查地址是否正确持有 NFT
    expect(await nft.ownerOf(1)).to.equal(addr1.address);
    
    // 检查 tokenURI 是否设置正确
    expect(await nft.tokenURI(1)).to.equal(tokenURI);
    // 将 NFT 转移给 addr2
    await nft.connect(addr1).transferFrom(addr1.address, addr2.address, 1);
    
    // 检查新持有者
    expect(await nft.ownerOf(1)).to.equal(addr2.address);
  });

  it("should fail to transfer if not owner or approved", async function () {
    const tokenURI = "https://example.com/metadata/2";
    await nft.mintNFT(addr1.address, tokenURI);
    // 尝试从没有授权的账户转移 NFT
    await expect(
      nft.connect(addr2).transferFrom(addr1.address, addr2.address, 1)
    ).to.be.revertedWith("ERC721: transfer caller is not owner nor approved");
  });
});
```

### 测试代码说明

1. **测试铸造和转移 ** **NFT** ：首先铸造一个新的 NFT，检查持有者是否正确，然后将该 NFT 转移给另一个账户，最后检查新的持有者。
2. **测试未授权转移失败** ：尝试从没有授权的账户转移 NFT，确保交易会正确失败。

### 运行测试

使用 Hardhat 安装依赖后，运行以下命令来执行测试：

```Bash
npx hardhat test
```

### 自定义扩展功能

你可以在此基础上为合约添加更多功能，例如：

1. **限制铸造数量** ：可以设置一个最大供应量，确保 NFT 的稀缺性。
2. **增加批量铸造功能** ：允许一次性铸造多个 NFT。
3. **增加销售功能** ：你可以实现 NFT 的销售机制，用户可以支付一定的费用来铸造 NFT。
4. **设置 ****NFT** ** 的元数据（**  **`tokenURI`**  **）** ：可以通过链外存储（如 IPFS）保存 NFT 的元数据，并在合约中使用 `tokenURI` 来指向这些数据。

### 进一步扩展

* **IPFS** ：为了去中心化存储 NFT 元数据和图片，通常使用 IPFS（InterPlanetary File System）来存储这些文件，并将 IPFS 的哈希值作为 `tokenURI`。
* **Marketplace** ：你可以构建一个自己的 NFT 市场，允许用户买卖 NFT，或实现像 OpenSea 一样的二级市场功能。

### 总结

* 我们实现了一个符合 ERC-721 标准的简单 NFT 合约，允许铸造、转移和查询 NFT。
* 我们使用 Hardhat 编写并运行了测试，验证了合约的核心功能。
* 通过 OpenZeppelin 的实现，开发者可以快速、安全地创建自己的 NFT 合约，同时也可以根据需要进行扩展和定制。
