// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Campaign {
    address public owner;
    uint256 public totalMembers;
    uint256 public approvalsNeeded;
    uint256 public approvals;
    uint256 public fee = 10;
    uint256 public campaignStatus;

    mapping(address => bool) public members;
    mapping(address => bool) public proposals;

    enum CampaignStatus { Active, Approved, Denied, Running, Completed }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only contract owner can call this function");
        _;
    }

    modifier onlyMembers() {
        require(members[msg.sender], "Only members can call this function");
        _;
    }

    constructor() {
        owner = msg.sender;
        totalMembers = 0;
        approvalsNeeded = 0;
        approvals = 0;
        campaignStatus = uint256(CampaignStatus.Active);
    }

    function addMember(address _member) external payable {
        require(msg.value == fee, "Fee of 10 finney required to add a member");
        require(!members[_member], "Member already exists");
        members[_member] = true;
        totalMembers++;
        approvalsNeeded = (totalMembers * 51) / 100;
    }

    function sendProposal(address _proposal) external onlyOwner {
        proposals[_proposal] = true;
    }

    function getCampaignStatus() external view returns (CampaignStatus) {
        if (approvals >= approvalsNeeded) {
            return CampaignStatus.Approved;
        }
        return CampaignStatus.Active;
    }

    function executeCampaign() external onlyOwner {
        require(campaignStatus == uint256(CampaignStatus.Approved), "Campaign not approved yet");
        campaignStatus = uint256(CampaignStatus.Running);
    }
}
