pragma solidity 0.8.9;

//SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

import "./ERC20Vesting.sol";
import "./Referral.sol";
import "./Withdrawable.sol";

abstract contract ERC20VestingBuyable is ERC20Vesting, Referral, Withdrawable {
    using SafeERC20 for IERC20;

    mapping(address => uint256) public tokenPrice; //in thousandths

    uint256 public buyStart;
    uint256 public buyEnd;

    constructor(string memory _name, string memory _symbol, uint256 _cap) ERC20Vesting(_name, _symbol, _cap) {}

    function setBuyTiming(uint256 _start, uint256 _end) external onlyOwner {
        require(block.number < _start, "Can't start buy in the past");
        require(_start < _end, "Buy phase must have a duration");
        buyStart = _start;
        buyEnd = _end;
        emit BuyTiming(_start, _end);
    }

    function isBuyOpen(uint256 _block) public view returns(bool) {
        return _block > buyStart && _block < buyEnd;
    }

    function buy(uint256 _amount, address _with) external {
        _buy(_amount, _with);
    }

    function buyWithReferral(uint256 _amount, address _with, address _referrer) external {
        _buy(_amount, _with);
        referralManager.refer(_referrer, _msgSender(), _amount);
    }

    function _buy(uint256 _amount, address _with) virtual internal {
        require(isBuyOpen(block.number), "Buy window is not open");
        require(tokenPrice[_with] != 0, "Buying with a not allowed token");
        IERC20(_with).safeTransferFrom(_msgSender(), address(this), buyPrice(_amount, _with));
        _mint(_msgSender(), _amount);
        referralManager.enable(_msgSender());
        emit Bought(_msgSender(), _with, _amount);
    }

    function acceptToken(address _token, uint256 _price) onlyOwner external {
        require(_price > 0, "Buy rate must be greater than 0");
        tokenPrice[_token] = _price;
        emit AcceptedToken(_token, _price);
    }

    function revokeToken(address _token) onlyOwner external {
        tokenPrice[_token] = 0;
        emit RevokedToken(_token);
    }

    function buyPrice(uint256 _amount, address _with) public view returns(uint256) {
        return _amount * tokenPrice[_with] / 1000;
    }

    event Bought(address indexed buyer, address indexed with, uint256 amount);
    event AcceptedToken(address indexed token, uint256 price);
    event RevokedToken(address indexed token);
    event BuyTiming(uint256 start, uint256 end);
}