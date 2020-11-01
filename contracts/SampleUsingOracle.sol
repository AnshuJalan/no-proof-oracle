pragma solidity ^0.5.0;

import "./user_contracts/UsingOracle.sol";

/**
* @dev Sample implmentation of UsingOracle in a smart contract.
* All responses will be stored in 'latestReponse' mapping.
* @notice preferrably have a separate variable in your implementation
* to hold your requestIds.
*/
contract SampleUsingOracle is UsingOracle {
  constructor(address _oracleAddress) UsingOracle(_oracleAddress) public {}

  uint256 latestResponseId;

  /**
  * @notice This is Eth price only for this sample. This could be anything else,
  * depending upon your usecase and oracle-server setup.
  */
  function requestEthPrice() public {
    latestResponseId = requestData(1);
  }

  function getEthPrice() public view returns(uint256){
    return latestResponse[latestResponseId];
  }
} 