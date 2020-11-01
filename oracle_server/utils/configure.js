const Web3 = require("web3");
const Oracle = require("../../build/contracts/OracleProxy.json");
const ImplementationJSON = require("../../build/contracts/Oracle.json");

async function init() {
  const web3 = new Web3("ws://localhost:8545");
  web3.eth.defaultAccount = (await web3.eth.getAccounts())[0];
  const networkId = await web3.eth.net.getId();
  const oracleNetwork = Oracle.networks[networkId];

  const oracle = new web3.eth.Contract(Oracle.abi, oracleNetwork.address);

  return { oracleAbi: ImplementationJSON.abi, oracle, web3 };
}

module.exports = {
  init,
};
