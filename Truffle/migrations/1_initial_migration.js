var SampleContract = artifacts.require("SampleContract");
//var LotteryContract = artifacts.require("LotteryContract");

module.exports = function(deployer) {
  // deployment steps
 deployer.deploy(SampleContract);
 // deployer.deploy(LotteryContract);
};