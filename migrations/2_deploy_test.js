const Oracle = artifacts.require("Oracle");
const OracleProxy = artifacts.require("OracleProxy");
const UsingOracle = artifacts.require("UsingOracle");

module.exports = function (deployer) {
  deployer.deploy(Oracle).then(() => {
    return deployer.deploy(OracleProxy, Oracle.address).then(() => {
      return deployer.deploy(UsingOracle, OracleProxy.address);
    });
  });
};
