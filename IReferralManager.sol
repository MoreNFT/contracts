pragma solidity 0.8.9;

//SPDX-License-Identifier: MIT

interface IReferralManager {
    function enable(address _buyer) external;
    function refer(address _referrer, address _referred, uint256 _amount) external;
}