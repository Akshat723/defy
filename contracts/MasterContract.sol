// MasterContract.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MasterContract {
    address public owner;
    mapping(address => uint256) public balances;

    event Deposit(address indexed sender, uint256 amount);
    event GasFundsApproved(address indexed childContract, uint256 amount);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }

    receive() external payable {
        emit Deposit(msg.sender, msg.value);
    }

    function deposit() external payable {
        require(msg.value > 0, "Deposit amount must be greater than 0");
        balances[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    function approveGasFunds(address childContract, uint256 amount) external onlyOwner {
        require(amount > 0, "Amount must be greater than 0");
        require(balances[address(this)] >= amount, "Insufficient funds in MasterContract");

        balances[address(this)] -= amount;
        emit GasFundsApproved(childContract, amount);
    }
}
