const Web3 = require("web3");
const Oracle = require("../../build/contracts/OracleProxy.json");

async function init() {
  const web3 = new Web3("ws://localhost:8545");
  const networkId = await web3.eth.net.getId();
  const oracleNetwork = Oracle.networks[networkId];

  const oracle = new web3.eth.Contract(Oracle.abi, oracleNetwork.address);

  return { oracleAbi: Oracle.abi, oracle, web3 };
}

module.exports = {
  init,
};
