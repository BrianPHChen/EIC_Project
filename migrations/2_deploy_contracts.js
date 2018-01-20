var SafeMath = artifacts.require("./SafeMath.sol");
var EICToken = artifacts.require("./Token.sol");
var CrowdSales = artifacts.require("./CrowdSales.sol");
var PrivateSales = artifacts.require("./PrivateSales.sol");

var lockBlockPeriod = 0;

module.exports = function(deployer) {
  deployer.deploy(SafeMath);
  deployer.link(SafeMath, EICToken);
  deployer.link(SafeMath, CrowdSales);
  deployer.link(SafeMath, PrivateSales);

  deployer.deploy(EICToken, lockBlockPeriod);
  deployer.deploy(CrowdSales);
  deployer.deploy(PrivateSales);
};
