var LPToken = artifacts.require("LendingPoolToken");

module.exports = function(deployer) {
  deployer.deploy(LPToken);
};