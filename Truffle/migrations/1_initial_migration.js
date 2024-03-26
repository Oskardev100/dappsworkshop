var SampleContract = artifacts.require("SampleContract");

module.exports = function(deployer) {
  // deployment steps
 deployer.deploy(SampleContract);
};