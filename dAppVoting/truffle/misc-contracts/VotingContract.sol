// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SampledAppVoting {
  // Structure to store campaign information
  struct Campaign {
    string title;
    string description;
    uint fundingGoal;
    uint currentBalance;
    bool isActive;
    bool isApproved;
    bool isExecuted;
    address payable owner;
  }

  // Mapping to store members and their voting status for a campaign
  mapping(address => mapping(uint => bool)) public hasVoted;

  // Address of the contract creator (owner)
  address payable public owner;

  // Minimum fee to become a member
  uint public constant membershipFee = 1e17; // 0.001 ETH (assuming 1 ETH = 1e18 Wei)

  // Array to store all campaigns
  Campaign[] public campaigns;
  // Modifier to restrict access to owner-only functions
  modifier onlyOwner() {
    require(msg.sender == owner, "Only owner can call this function");
    _;
  }

  // Event to notify about a new campaign proposal
  event ProposalSubmitted(uint campaignId, string title, string description, uint fundingGoal, address owner);

  // Event to notify about a vote on a campaign
  event Voted(uint campaignId, address member, bool vote);

  // Event to notify about campaign status change
  event CampaignStatusChanged(uint campaignId, string status);

  // Constructor to store the owner address
  constructor() {
    owner = payable(msg.sender);
  }

  // Function to submit a new campaign proposal (onlyOwner)
  function SendProposal(string memory title, string memory description, uint fundingGoal) public onlyOwner {
    campaigns.push(Campaign({
      title: title,
      description: description,
      fundingGoal: fundingGoal,
      currentBalance: 0,
      isActive: true,
      isApproved: false,
      isExecuted: false,
      owner: payable(msg.sender)
    }));

    emit ProposalSubmitted(campaigns.length - 1, title, description, fundingGoal, msg.sender);
  }

  // Function to become a member by paying the fee
  function AddMember() public payable {
    require(msg.value >= membershipFee, "Insufficient funds to become a member");
    // Add member logic (e.g., add address to a member list)
  }

  // Function to vote on a campaign (accessible to all members)
  function Vote(uint campaignId, bool approve) public {
    require(!hasVoted[msg.sender][campaignId], "Already voted on this campaign");
    hasVoted[msg.sender][campaignId] = true;
    emit Voted(campaignId, msg.sender, approve);

    // Update campaign approval status based on voting logic (e.g., majority vote)
    if (isCampaignApproved(campaignId)) {
      campaigns[campaignId].isApproved = true;
      emit CampaignStatusChanged(campaignId, "Approved");
    }
  }

  // Function to contribute funds to the active campaign
  function FundCampaign() public payable {
    require(campaigns.length > 0, "No active campaign");
    require(campaigns[campaigns.length - 1].isActive, "Campaign is not active");
    campaigns[campaigns.length - 1].currentBalance += msg.value;
  }

  // Function to check if a campaign is approved (internal)
  function isCampaignApproved(uint campaignId) internal view returns (bool) {
    uint totalVotes = 0;
    uint approveCount = 0;

    // Implement logic to iterate through members and count votes (consider gas optimization)

    return approveCount > totalVotes / 2;
  }

  // Function to get campaign status
  function GetCampaignStatus(uint campaignId) public view returns (string memory) {
    require(campaignId < campaigns.length, "Invalid campaign ID");

    if (campaigns[campaignId].isActive) {
      return "Active";
    } else if (campaigns[campaignId].isApproved) {
      return "Approved";
    } else if (campaigns[campaignId].isExecuted) {
      return "Executing";
    } else {
      return "Completed";
    }
  }

  // Function to execute the approved campaign (onlyOwner)
  function ExecuteCampaign(uint campaignId) public onlyOwner {
    require(campaigns[campaignId].isApproved, "Campaign is not approved");
    campaigns[campaignId].isActive = false;
    
    campaigns[campaignId].isExecuted = true;
  }

//   // Function to execute the approved campaign (onlyOwner)
//   function CompleteCampaign(uint campaignId) public onlyOwner {
//     require(campaigns[campaignId].isExecuted, "Campaign is not executued");
//     campaigns[campaignId].isExecuted = false;
    
//     campaigns[campaignId].isComplete = true;
//   }

}