pragma solidity ^0.8.0;

//SPDX-License-Identifier: MIT

import "./ERC20Vesting.sol";
import "./Referral.sol";

abstract contract ERC20VestingMintable is ERC20Vesting, Referral {

    constructor(string memory _name, string memory _symbol, uint256 _cap) ERC20Vesting(_name, _symbol, _cap) {}

    function mint(address _to, uint256 _amount) external virtual onlyOwner {
        require(tge == 0 || block.timestamp < tge, "Can only mint before TGE");
        _mint(_to, _amount);
        referralManager.enable(_to);
    }
}