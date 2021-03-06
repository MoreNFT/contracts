pragma solidity 0.8.9;

//SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

import "./Creator.sol";

contract MoreNFTCollectionUnique is ERC721Enumerable, ERC721URIStorage, ERC721Burnable, Ownable, Creator {

    constructor(string memory name_, string memory symbol_) ERC721(name_, symbol_) {}

    function safeMint(address creator, address to, uint256 tokenId, string memory uri) external onlyOwner {
        require(keccak256(abi.encodePacked(uri)) != keccak256(abi.encodePacked("")), "URI can't be empty");
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
        _setCreator(tokenId, creator);
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId) public view override(ERC721, ERC721Enumerable) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}