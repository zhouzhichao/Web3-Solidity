const { expect } = require("chai");

describe("MyNFT", function () {
    let MyNFT, nft, owner, addr1, addr2;

    beforeEach(async function () {
        MyNFT = await ethers.getContractFactory("MyNFT");
        [owner, addr1, addr2] = await ethers.getSigners();

        // 设置最大供应量为 5
        nft = await MyNFT.deploy(5);
        await nft.deployed();
    });

    it("should mint an NFT and assign it to the correct owner", async function () {
        const tokenURI = "https://example.com/metadata/1";
        await nft.mintNFT(addr1.address, tokenURI);

        expect(await nft.ownerOf(1)).to.equal(addr1.address);
        expect(await nft.tokenURI(1)).to.equal(tokenURI);
    });

    it("should fail to mint more NFTs than the max supply", async function () {
        // 铸造 5 个 NFT
        for (let i = 1; i <= 5; i++) {
            const tokenURI = `https://example.com/metadata/${i}`;
            await nft.mintNFT(addr1.address, tokenURI);
        }

        // 尝试铸造第 6 个 NFT 应该失败
        await expect(nft.mintNFT(addr1.address, "https://example.com/metadata/6")).to.be.revertedWith(
            "All NFTs have been minted"
        );
    });

    it("should allow owner to transfer an NFT", async function () {
        const tokenURI = "https://example.com/metadata/2";
        await nft.mintNFT(addr1.address, tokenURI);

        // addr1 转移 NFT 给 addr2
        await nft.connect(addr1).transferFrom(addr1.address, addr2.address, 1);

        expect(await nft.ownerOf(1)).to.equal(addr2.address);
    });

    it("should fail to transfer if not owner or approved", async function () {
        const tokenURI = "https://example.com/metadata/3";
        await nft.mintNFT(addr1.address, tokenURI);

        // addr2 尝试从 addr1 转移 NFT，应该失败
        await expect(
            nft.connect(addr2).transferFrom(addr1.address, addr2.address, 1)
        ).to.be.revertedWith("ERC721: transfer caller is not owner nor approved");
    });

    it("should allow owner to burn their NFT", async function () {
        const tokenURI = "https://example.com/metadata/4";
        await nft.mintNFT(addr1.address, tokenURI);

        // addr1 销毁 NFT
        await nft.connect(addr1).burnNFT(1);

        // NFT 应该不存在
        await expect(nft.ownerOf(1)).to.be.revertedWith("ERC721: owner query for nonexistent token");
    });

    it("should fail to burn if not the owner", async function () {
        const tokenURI = "https://example.com/metadata/5";
        await nft.mintNFT(addr1.address, tokenURI);

        // addr2 尝试销毁 addr1 的 NFT，应该失败
        await expect(nft.connect(addr2).burnNFT(1)).to.be.revertedWith("You do not own this token");
    });
});