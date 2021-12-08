pragma solidity ^0.8.0;

//SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract MoreNFTTokenomics is ERC20Capped, Ownable {
    using SafeERC20 for IERC20;

    IERC20 public mainToken;
    mapping(address => uint256) public monthlyClaim;
    uint256 public totalClaimed;

    uint256 public tge;

    constructor(string memory _name, string memory _symbol, uint256 _cap) ERC20(_name, _symbol) ERC20Capped(_cap) {}

    function setTGE(uint256 _time, address _mainToken) external onlyOwner {
        require(tge == 0, "TGE already set");
        tge = _time;
        mainToken = IERC20(_mainToken);
        require(mainToken.balanceOf(address(this)) > ERC20.totalSupply(), "Main token contract must transfer seed token to this contract");
        emit TGE(_time, _mainToken);
    }

    function claim(address _to, uint256 _untilMonth) external {
        require(_untilMonth <= currentMonth(block.timestamp), "Must wait tokenomics timeline");
        uint256 claimableTokens;
        for (uint256 i=monthlyClaim[_to]+1; i<=_untilMonth; i++) {
            claimableTokens += _claimablePerMonth(_to, i);
        }
        require(claimableTokens > 0, "Claiming 0 tokens");
        mainToken.safeTransfer(_to, claimableTokens);
        totalClaimed += claimableTokens;
        monthlyClaim[_to] = _untilMonth;
        emit Claimed(_to, claimableTokens);
    }

    function _claimablePerMonth(address _to, uint256 _month) public view returns(uint256) {
        return _tokenClaimPerMonth(_month) * balanceOf(_to) / 10000;
    }

    function _tokenClaimPerMonth(uint256 _month) internal pure returns(uint256) {
        require(_month > 0, "Seed token are locked for the first month");
        if (_month == 1)
            return 1000;
        if (_month < 24)
            return 375;
        return 0;
    }

    function currentMonth(uint256 _time) public view returns(uint256) {
        require(tge > 0, "TGE not set");
        return (_time - tge) / 30 days;
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual override {
        require(from == address(0), "Users' transfers are disabled on the Seed Contract");
        require(tge == 0, "Can only mint before TGE");
    }

    event TGE(uint256 time, address tokenAddress);
    event Claimed(address indexed claimer, uint256 indexed amount);
}