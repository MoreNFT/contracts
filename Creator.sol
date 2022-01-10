pragma solidity 0.8.9;

//SPDX-License-Identifier: MIT

contract Creator {
    mapping(uint256 => address) public _creators;

    function _setCreator(uint256 tokenId, address creator) internal virtual {
        require(creator != address(0), "Creator can't be the zero address");
        _creators[tokenId] = creator;
    }

    function getCreator(uint256 tokenId) external view returns(address) {
        return _creators[tokenId];
    }
}