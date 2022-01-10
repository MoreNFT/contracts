pragma solidity 0.8.9;

//SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/Ownable.sol";

import "./IReferralManager.sol";

contract Referral is Ownable {
    IReferralManager public referralManager;

    function setReferralManager(address _referralManager) external onlyOwner {
        referralManager = IReferralManager(_referralManager);
        emit ReferralManager(_referralManager);
    }

    event ReferralManager(address manager);
}