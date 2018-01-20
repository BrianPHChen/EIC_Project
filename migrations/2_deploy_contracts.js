var EICToken = artifacts.require("./EICToken.sol");
var CrowdSales = artifacts.require("./CrowdSales.sol");
var PrivateSales = artifacts.require("./PrivateSales.sol");

var lockBlockPeriod = 0;

module.exports = function(deployer) {
	deployer.deploy(EICToken, lockBlockPeriod);
 	deployer.deploy(CrowdSales);
    deployer.deploy(PrivateSales);
};
