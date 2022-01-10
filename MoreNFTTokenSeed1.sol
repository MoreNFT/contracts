pragma solidity 0.8.9;

//SPDX-License-Identifier: MIT

import "./ERC20VestingMintable.sol";

contract MoreNFTTokenSeed1 is ERC20VestingMintable {
    constructor() ERC20VestingMintable("MoreNFTTokenSeed1", "MRN-SEED1", 8 * 10**6 * 10**18) {}

    function _tokenClaimPerMonth(uint256 _month) internal override pure returns(uint256) {
        if (_month == 1)
            return 1000;
        if (_month > 1 && _month < 26)
            return 375;
        return 0;
    }
}