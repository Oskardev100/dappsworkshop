// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract SimpleStorage {
  
  uint256 value;
  
  struct Campaign {
    string title;
    string description;
  }
  
  // Function to withdraw all collected funds to the owner (only accessible by owner)
  modifier onlyOwner() {
    require(msg.sender == owner, "Only owner can withdraw funds");
    _;
  }
  
  Campaign[] public campaigns;

    // State variable to store the total amount collected
  uint public balance;

  // Address of the contract creator (owner)
  address payable public owner;



  // Constructor to store the owner address
  constructor() {
    owner = payable(msg.sender);
  }



  function read() public view returns (uint256) {
    return value;
  }

  function write(uint256 newValue) public {
    value = newValue;
  }

  // Function to collect funds to the contract
  function Found() public payable {
    balance += msg.value;
  }


  function PayVendor() public onlyOwner {
    // Transfer the entire balance to the owner
    owner.transfer(balance);
    balance = 0;
  }

  // Function to add a new campaign
  function addCampaign(string memory _title, string memory _description) public {
    Campaign memory newCampaign = Campaign(_title, _description);
    campaigns.push(newCampaign);
  }
}