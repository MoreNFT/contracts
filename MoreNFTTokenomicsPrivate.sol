pragma solidity ^0.8.0;

//SPDX-License-Identifier: MIT

import "./MoreNFTTokenomics.sol";

contract MoreNFTTokenomicsPrivate is MoreNFTTokenomics {

    constructor(string memory _name, string memory _symbol, uint256 _cap) MoreNFTTokenomics(_name, _symbol, _cap) {}

    function mint(address _to, uint256 _amount) external virtual onlyOwner {
        _mint(_to, _amount);
    }
}