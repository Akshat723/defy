// ChildContract.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./MasterContract.sol";

contract ChildContract {
    address public masterContract;
    address public owner;
    
    event GasFundsRequested(uint256 amount);
    event TransferCompleted(address indexed recipient, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }

    constructor(address _masterContract) {
        masterContract = _masterContract;
        owner = msg.sender;
    }

    function requestGasFunds(uint256 amount) external onlyOwner {
        require(amount > 0, "Amount must be greater than 0");
        MasterContract(masterContract).approveGasFunds(address(this), amount);
        emit GasFundsRequested(amount);
    }

    function transferTo(address recipient, uint256 amount) external onlyOwner {
        require(amount > 0, "Amount must be greater than 0");
        require(MasterContract(masterContract).balances(address(this)) >= amount, "Insufficient funds in ChildContract");

        MasterContract(masterContract).balances(address(this)) -= amount;

        // Emulating the transfer logic for demonstration purposes.
        // In reality, you would integrate with a cross-chain solution or bridge.
        emit TransferCompleted(recipient, amount);
    }
}
