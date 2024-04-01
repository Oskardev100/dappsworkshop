// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract SimpleStorage {
  uint256 value;

  function read() public view returns (uint256) {
    return value;
  }

  function write(uint256 newValue) public {
    value = newValue;
  }

    // State variable to store the total amount collected
  uint public balance;

  // Address of the contract creator (owner)
  address payable public owner;

  // Constructor to store the owner address
  constructor() {
    owner = payable(msg.sender);
  }

  // Function to collect funds to the contract
  function Found() public payable {
    balance += msg.value;
  }

  // Function to withdraw all collected funds to the owner (only accessible by owner)
  modifier onlyOwner() {
    require(msg.sender == owner, "Only owner can withdraw funds");
    _;
  }

  function PayVendor() public onlyOwner {
    // Transfer the entire balance to the owner
    owner.transfer(balance);
    balance = 0;
  }
}