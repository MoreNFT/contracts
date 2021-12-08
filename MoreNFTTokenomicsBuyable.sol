pragma solidity ^0.8.0;

import "./MoreNFTTokenomics.sol";
import "./Withdrawable.sol";

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract MoreNFTTokenomicsBuyable is MoreNFTTokenomics, Withdrawable {
    using SafeERC20 for IERC20;

    mapping(address => uint256) public tokenPrice; //in thousandths

    constructor(string memory _name, string memory _symbol, uint256 _cap) MoreNFTTokenomics(_name, _symbol, _cap) {}

    function buy(uint256 _amount, address _with) external {
        require(tokenPrice[_with] != 0, "Buying with a not allowed token");
        IERC20(_with).safeTransferFrom(_msgSender(), address(this), buyPrice(_amount, _with));
        _mint(_msgSender(), _amount);
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
        return _amount / 1000 * tokenPrice[_with];
    }

    event Bought(address indexed buyer, address indexed with, uint256 amount);
    event AcceptedToken(address indexed token, uint256 price);
    event RevokedToken(address indexed token);
}