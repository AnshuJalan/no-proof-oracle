const axios = require("axios");
const level = require("level");

const configure = require("./utils/configure");
const { CHUNK_SIZE, SLEEP_INTERVAL } = require("./constants");

const db = level("./oracle_server/apiStore");

const requestQueue = [];

function startEventListener(oracle) {
  oracle.events
    .NewRequestFromUser({})
    .on("data", (event) => addIdToRequestQueue(event));
}

function addIdToRequestQueue(event) {
  const id = event.returnValues.id;
  const apiId = event.returnValues.apiId;
  requestQueue.push({ id, apiId });
  console.log(`Received Request Id: ${id}`);
}

async function processRequest({ id, apiId, oracleAddress, oracleAbi, web3 }) {
  try {
    const apiURL = await db.get(apiId);
    const result = await axios.get(apiURL);

    await web3.eth.sendTransaction({
      to: oracleAddress,
      data: web3.eth.abi.encodeFunctionCall(oracleAbi[5], [
        id,
        Math.round(result.data[0].price),
      ]),
    });

    console.log(`*-- Processed Request Id: ${id}`);
  } catch (err) {
    console.log("Error: ", err);
  }
}

async function processQueue(oracleAbi, oracle, web3) {
  let processedRequests = 0;
  while (requestQueue.length > 0 && processedRequests < CHUNK_SIZE) {
    const { id, apiId } = requestQueue.shift();
    await processRequest({
      id,
      apiId,
      oracleAddress: oracle.options.address,
      oracleAbi,
      web3,
    });
    processedRequests++;
  }
}

(async () => {
  const { oracleAbi, oracle, web3 } = await configure.init();
  startEventListener(oracle);
  setInterval(() => {
    processQueue(oracleAbi, oracle, web3);
  }, SLEEP_INTERVAL);
})();
