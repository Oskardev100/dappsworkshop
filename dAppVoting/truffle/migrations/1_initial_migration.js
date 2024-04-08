var votingContract = artifacts.require("VotingContract.sol");

module.exports = function(deployer) {
  // deployment steps
 deployer.deploy(votingContract);
};