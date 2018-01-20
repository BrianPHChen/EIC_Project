var EICToken = artifacts.require("./Token.sol");
var CrowdSales = artifacts.require("./CrowdSales.sol");
var PrivateSales = artifacts.require("./PrivateSales.sol");

var lockBlockPeriod = 0;

module.exports = function(deployer) {
  return setup(deployer);
};

async function setup (deployer) {
  let token = await deployer.deploy(EICToken, lockBlockPeriod);
  console.log('Token address: ' + token.address);
  let crowdSale = await deployer.deploy(CrowdSales);
  console.log('CrowdSale: ' + crowdSale.address);
  let publicSetupHash = await crowdSale.setUP(token.address);
  console.log('Public setup tx hash:', publicSetupHash);
  let privateSale = await deployer.deploy(PrivateSales);
  console.log('PrivateSale: ' + privateSale.address);
  let privateSetupHash = await privateSale.setUP(token.address);
  console.log('Private setup tx hash:', privateSetupHash);
}
