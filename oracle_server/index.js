const configure = require("./utils/configure");

function startEventListener(oracle) {
  oracle.events
    .NewRequestFromUser({})
    .on("data", (event) => console.log(event));
}

(async () => {
  const { oracleAbi, oracle, web3 } = await configure.init();
  startEventListener(oracle);
})();
