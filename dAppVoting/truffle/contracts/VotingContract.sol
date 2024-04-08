// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract SimpleVoting {

  // Mapping to store the vote count for each option
  mapping(uint => uint) public votes;

  // Array to store the options available for voting
  string[] public options;

  // Function to add a new voting option (only callable once per option)
  function addOption(string memory option) public {
    require(!hasOption(option), "Option already exists");
    options.push(option);
  }

  // Function to check if an option already exists
  function hasOption(string memory option) public view returns (bool) {
    for (uint i = 0; i < options.length; i++) {
      if (keccak256(abi.encodePacked(options[i])) == keccak256(abi.encodePacked(option))) {
        return true;
      }
    }
    return false;
  }

  // Function to cast a vote for a specific option (accessible to all)
  function vote(uint optionIndex) public {
    require(optionIndex < options.length, "Invalid option index");
    votes[optionIndex] += 1;
  }

  // Function to get the total number of votes for a specific option
  function getVotes(uint optionIndex) public view returns (uint) {
    require(optionIndex < options.length, "Invalid option index");
    return votes[optionIndex];
  }
}
