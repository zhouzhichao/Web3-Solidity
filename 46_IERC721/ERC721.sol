// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyNFT is ERC721URIStorage, Ownable {
    // 当前 tokenId 计数器
    uint256 private _tokenIds;

    // 最大供应量限制
    uint256 public maxSupply;

    // 事件：当 NFT 被销毁时触发
    event Burn(address indexed owner, uint256 indexed tokenId);

    // 构造函数，初始化合约的名称、符号和最大供应量
    constructor(uint256 _maxSupply) ERC721("MyNFT", "MNFT") {
        maxSupply = _maxSupply;
    }

    // 自定义铸造功能: 铸造新 NFT，只有合约拥有者可以铸造
    function mintNFT(address recipient, string memory tokenURI) public onlyOwner returns (uint256) {
        require(_tokenIds < maxSupply, "All NFTs have been minted");

        _tokenIds += 1;
        uint256 newItemId = _tokenIds;

        _mint(recipient, newItemId); // 铸造新 NFT
        _setTokenURI(newItemId, tokenURI); // 设置 NFT 的 URI

        return newItemId;
    }

    // 自定义销毁功能: 销毁 NFT
    function burnNFT(uint256 tokenId) public {
        require(ownerOf(tokenId) == msg.sender, "You do not own this token");

        _burn(tokenId); // 销毁 NFT
        emit Burn(msg.sender, tokenId); // 触发销毁事件
    }

    // 获取当前已铸造的 NFT 总量
    function totalMinted() public view returns (uint256) {
        return _tokenIds;
    }
}