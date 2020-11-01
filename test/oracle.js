const UsingOracle = artifacts.require("UsingOracle");
const Oracle = artifacts.require("OracleProxy");

const oracleJSON = require("../build/contracts/Oracle.json");

contract("Oracle", async (accounts) => {
  let [alice, bob] = accounts;
  let usingOracle, oracle;

  beforeEach(async () => {
    usingOracle = await UsingOracle.deployed();
    oracle = await Oracle.deployed();
  });

  it("deploys oracle properly", async () => {
    assert(oracle.address !== "");
  });

  it("allows data submission", async () => {
    await usingOracle.requestData(1, { from: alice });
    const result = await oracle.sendTransaction({
      from: bob,
      data: web3.eth.abi.encodeFunctionCall(oracleJSON.abi[3], [0, 356]),
    });

    assert(result.logs[0].args.data.toNumber() === 356);
  });

  it("usingOracle receives submitted values", async () => {
    const val = await usingOracle.latestResponse(0);
    assert(val.toNumber() === 356);
  });
});
