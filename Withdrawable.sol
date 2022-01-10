pragma solidity 0.8.9;

// SPDX-License-Identifier: UNLICENSED

import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

abstract contract Withdrawable is Ownable {
    using SafeERC20 for IERC20;

    event Withdrawn(address from, address to, uint256 amount);

    function withdraw(address _token, address _to) external onlyOwner {
        IERC20 foreignToken = IERC20(_token);
        uint256 amount = foreignToken.balanceOf(address(this));
        require(amount > 0, "Can't withdraw 0");
        foreignToken.safeTransfer(_to, amount);
        emit Withdrawn(_msgSender(), _to, amount);
    }
}