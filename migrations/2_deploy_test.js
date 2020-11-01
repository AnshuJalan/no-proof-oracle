const Oracle = artifacts.require("Oracle");
const OracleProxy = artifacts.require("OracleProxy");
const SampleUsingOracle = artifacts.require("SampleUsingOracle");

module.exports = function (deployer) {
  deployer.deploy(Oracle).then(() => {
    return deployer.deploy(OracleProxy, Oracle.address).then(() => {
      return deployer.deploy(SampleUsingOracle, OracleProxy.address);
    });
  });
};
