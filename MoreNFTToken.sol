pragma solidity ^0.8.0;

//SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/token/ERC20/presets/ERC20PresetFixedSupply.sol";

contract MoreNFTToken is ERC20PresetFixedSupply {
    constructor() ERC20PresetFixedSupply("MoreNFTToken", "MRT", 200 * 10**6 * 10**18, _msgSender()) {}
}