pragma solidity 0.8.9;

//SPDX-License-Identifier: MIT

import "./ERC20VestingReferral.sol";

contract MoreNFTTokenReferral is ERC20VestingReferral {
    constructor() ERC20VestingReferral("MoreNFTTokenReferral", "MRN-REFER", 8 * 10**6 * 10**18) {}

    function _tokenClaimPerMonth(uint256 _month) internal override pure returns(uint256) {
        if (_month == 3)
            return 1000;
        if (_month > 3 && _month < 28)
            return 375;
        return 0;
    }
}