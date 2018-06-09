var DogMarket = artifacts.require("./DogMarket.sol");

module.exports = function(deployer) {
  deployer.deploy(DogMarket);
};
