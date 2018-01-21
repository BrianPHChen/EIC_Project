var EICToken = artifacts.require("./EICToken.sol");
var CrowdSales = artifacts.require("./CrowdSales.sol");
var PrivateSales = artifacts.require("./PrivateSales.sol");

var lockBlockPeriod = 200;

module.exports = function(deployer) {
	deployer.deploy(EICToken, lockBlockPeriod).then(() => {
		deployer.deploy(CrowdSales, EICToken.address);
		deployer.deploy(PrivateSales, EICToken.address);
	});
};
