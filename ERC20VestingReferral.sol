pragma solidity 0.8.9;

//SPDX-License-Identifier: MIT

import "./ERC20Vesting.sol";

abstract contract ERC20VestingReferral is ERC20Vesting {

    mapping(address => uint256[2]) public saleContracts;
    mapping(address => uint256) public referrers;

    constructor(string memory _name, string memory _symbol, uint256 _cap) ERC20Vesting(_name, _symbol, _cap) {}

    modifier onlyTokenomics() {
        require(saleContracts[_msgSender()][0] > 0, "Only allowed tokenomics contracts can generate referral bonus");
        _;
    }

    function enable(address buyer) external onlyTokenomics {
        if (referrers[buyer] == 0) {
            referrers[buyer] = saleContracts[_msgSender()][0];
        }
    }

    function refer(address referrer, address buyer, uint256 amount) external onlyTokenomics {
        require(isReferrer(referrer), "Wrong referrer address provided");
        uint256 referrerBonus = amount * referrers[referrer] / 100;
        uint256 buyerBonus = amount * saleContracts[_msgSender()][1] / 100;
        _mint(referrer, referrerBonus);
        _mint(buyer, buyerBonus);
        emit ReferralBonus(referrer, buyer, referrerBonus, buyerBonus);
    }

    function isReferrer(address referrer) public view returns(bool) {
        return referrers[referrer] != 0;
    }

    function setSaleContract(address sale, uint256[2] memory percentages) external onlyOwner {
        require(percentages[0] + percentages[1] <= 100);
        saleContracts[sale] = percentages;
        emit SetSaleContract(sale, percentages[0], percentages[1]);
    }

    event SetSaleContract(address sale, uint256 referrerPercentage, uint256 referredPercentage);
    event ReferralBonus(address referrer, address buyer, uint256 referrerBonus, uint256 buyerBonus);
}