pragma solidity ^0.8.0;

//SPDX-License-Identifier: MIT

import "./ERC20VestingBuyable.sol";

contract MoreNFTTokenSeed2 is ERC20VestingBuyable {
    constructor() ERC20VestingBuyable("MoreNFTTokenSeed2", "MS2", 7 * 10**6 * 10**18) {}

    function _tokenClaimPerMonth(uint256 _month) internal override pure returns(uint256) {
        if (_month == 1)
            return 1000;
        if (_month > 1 && _month < 26)
            return 375;
        return 0;
    }
}