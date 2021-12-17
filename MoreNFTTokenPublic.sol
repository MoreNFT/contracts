pragma solidity ^0.8.0;

//SPDX-License-Identifier: MIT

import "./ERC20VestingBuyable.sol";

contract MoreNFTTokenPublic is ERC20VestingBuyable {
    constructor() ERC20VestingBuyable("MoreNFTTokenPublic", "MPB", 8 * 10**6 * 10**18) {}

    function _tokenClaimPerMonth(uint256 _month) internal override pure returns(uint256) {
        if (_month == 0) {
            return 10000;
        }
        return 0;
    }
}