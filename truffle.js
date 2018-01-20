
var env = require('./env.js');
var ethereumjsWallet = require('ethereumjs-wallet');
var ProviderEngine = require("web3-provider-engine");
var WalletSubprovider = require('web3-provider-engine/subproviders/wallet.js');
var Web3Subprovider = require("web3-provider-engine/subproviders/web3.js");
var Web3 = require("web3");
var FilterSubprovider = require('web3-provider-engine/subproviders/filters.js');

// create wallet from existing private key
var privateKey = env.privateKey;
var wallet = ethereumjsWallet.fromPrivateKey(new Buffer(privateKey, "hex"));
var address = "0x" + wallet.getAddress().toString("hex");

console.log(address);

// using ropsten testnet
var providerUrl = env.providerUrl;
var engine = new ProviderEngine();

// filters
engine.addProvider(new FilterSubprovider());
engine.addProvider(new WalletSubprovider(wallet, {}));
engine.addProvider(new Web3Subprovider(new Web3.providers.HttpProvider(providerUrl)));
engine.start(); // Required by the provider engine.

module.exports = {
  networks: {
    development: {
      host: "localhost",
      port: 8545,
      network_id: "*" // Match any network id
    },
    infuraRinkeby: {
      network_id: 4,    // Official ropsten network id
      provider: engine, // Use our custom provider
      from: address     // Use the address we derived
    },
  }
};
