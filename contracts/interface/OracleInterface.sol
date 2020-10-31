pragma solidity ^0.5.0;

interface OracleInterface {
  function getRequestedData(uint256) external view returns(uint256);
}