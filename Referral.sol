pragma solidity ^0.8.0;

//SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/Ownable.sol";

import "./IReferralManager.sol";

contract Referral is Ownable {
    IReferralManager public referralManager;

    function setReferralManager(address _referralManager) external onlyOwner {
        referralManager = IReferralManager(_referralManager);
    }
}