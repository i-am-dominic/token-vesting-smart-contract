// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts@5.0.2/token/ERC20/IERC20.sol";

contract Vesting {
    IERC20 public token;
    address public receiver;
    uint256 public amount;
    uint256 public expiry;
    bool public locked = false;
    bool public claimed = false;

    constructor (address _token) {
        token = IERC20(_token);
    }

    function lock(address _from, address _receiver, uint256 _amount, uint256 _expiry) external {
        require(locked == false, "This token is already locked");
        token.transferFrom(_from, address(this), _amount);
        receiver = _receiver;
        amount = _amount;
        expiry = _expiry;
        locked = true;
    }

    function withdraw() external {
        require(locked == true, "Funds have not been locked");
        require(block.timestamp > expiry, "Tokens have not been unlocked");
        require(claimed == false, "Tokens have already been claimed.");
        claimed = true;
        token.transfer(receiver, amount);
    }

    function getTime() external view returns (uint256) {
        return block.timestamp;
    }
}