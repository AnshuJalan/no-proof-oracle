const UsingOracle = artifacts.require("UsingOracle");
const Oracle = artifacts.require("OracleProxy");

contract("UsingOracle", async (accounts) => {
  let [alice, bob] = accounts;
  let usingOracle;

  beforeEach(async () => {
    usingOracle = await UsingOracle.deployed();
  });

  it("deploys usingOracle properly", async () => {
    assert(usingOracle !== "");
  });

  it("accepts data requests", async () => {
    let result = await usingOracle.requestData(1, { from: alice });
    const id = result.logs[0].args.requestId.toNumber();
    const apiId = result.logs[0].args.requestedApiId.toNumber();
    assert(id === 0 && apiId === 1);
  });

  it("oracle receives the request", async () => {
    const oracle = await Oracle.deployed();

    let requestCount = await oracle.getUintVar(
      "0x05de9147d05477c0a5dc675aeea733157f5092f82add148cf39d579cafe3dc98"
    );
    assert(requestCount.toNumber() === 1);
  });
});
