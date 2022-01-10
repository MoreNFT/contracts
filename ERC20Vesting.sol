pragma solidity 0.8.9;

//SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

abstract contract ERC20Vesting is ERC20Capped, Ownable {
    using SafeERC20 for IERC20;

    uint256 public BLOCK_TIME = 3; //BSC block time

    IERC20 public mainToken;
    mapping(address => uint256) public nextMonthToClaim;
    uint256 public totalClaimed;

    uint256 public tge;

    constructor(string memory _name, string memory _symbol, uint256 _cap) ERC20(_name, _symbol) ERC20Capped(_cap) {}

    function setTGE(uint256 _block, address _mainToken) external onlyOwner {
        require(tge == 0, "TGE already set");
        require(block.number <= _block, "Can't set TGE in the past");
        tge = _block;
        mainToken = IERC20(_mainToken);
        require(mainToken.balanceOf(address(this)) >= ERC20.totalSupply(), "Main token contract must transfer seed token to this contract");
        emit TGE(_block, _mainToken);
    }

    function claim(address _to, uint256 _untilMonth) external {
        require(_untilMonth <= currentMonth(block.number), "Must wait tokenomics timeline");
        uint256 claimableTokens = claimable(_to, _untilMonth);
        require(claimableTokens > 0, "Claiming 0 tokens");
        totalClaimed += claimableTokens;
        nextMonthToClaim[_to] = _untilMonth+1;
        mainToken.safeTransfer(_to, claimableTokens);
        emit Claimed(_to, claimableTokens);
    }

    function claimable(address _by, uint256 _untilMonth) public view returns(uint256) {
        uint256 claimableTokens;
        for (uint256 i=nextMonthToClaim[_by]; i<=_untilMonth; i++) {
            claimableTokens += claimablePerMonth(_by, i);
        }
        return claimableTokens;
    }

    function claimablePerMonth(address _to, uint256 _month) public view returns(uint256) {
        return _tokenClaimPerMonth(_month) * balanceOf(_to) / 10000;
        // /10000 is 100 for the percentage and 100 for the hundreds of percentage
    }

    // expressed in hundreds of percentage
    function _tokenClaimPerMonth(uint256 _month) internal virtual pure returns(uint256);

    function currentMonth(uint256 _block) public view returns(uint256) {
        require(tge > 0, "TGE not set");
        return (_block - tge) * BLOCK_TIME / 30 days;
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual override {
        super._beforeTokenTransfer(from, to, amount);
        require(from == address(0), "Users' transfers are disabled on tokenomics contracts");
    }

    event TGE(uint256 block, address tokenAddress);
    event Claimed(address indexed claimer, uint256 indexed amount);
}