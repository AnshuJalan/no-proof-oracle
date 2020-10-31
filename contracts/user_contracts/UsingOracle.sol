pragma solidity ^0.5.0;

import '../interface/OracleInterface.sol';

contract usingOracle {

  address private owner;
  address private oracleAddress;

  OracleInterface oracle;

  mapping(uint256 => bool) public requestsOpen;

  //Native to this implementation. Records the latest reponse for a particular apiId;
  mapping(uint256 => uint256) public latestResponse;

  event NewOracleAddress(address newOracleAddress);
  event NewRequest(uint256 requestId, uint256 requestedApiId);
  event ReceivedData(uint256 requestId, uint256 data);

  constructor(address _oracleAddress) public {
    oracleAddress = _oracleAddress;
    oracle = OracleInterface(oracleAddress);
    owner = msg.sender;
  }

  function updateOracleAddress(address _newOracleAddress) external onlyOwner{
    oracleAddress = _newOracleAddress;
    oracle = OracleInterface(oracleAddress);
  }

  /**
  * @param _apiId is native to this implementation.
  * Replace it with hash for a generic usecase.
  * @dev Data is the Eth price in USD for this implementation.
  * It could be anything generic too, as long as the data response in a integer.
  */
  function requestData(uint256 _apiId) internal {
    uint256 _id = oracle.getRequestedData(_apiId);
    requestsOpen[_id] = true;
    emit NewRequest(_id, _apiId);
  }

  function requestCallback(uint256 _id, uint256 _data) public isValidCall(_id){
    latestResponse[_id] = _data;
    delete requestsOpen[_id];
    emit ReceivedData(_id, _data);
  }

  modifier onlyOwner(){
    require(msg.sender == owner, "Not Authorized");
    _;
  }

  modifier isValidCall(uint256 _id){
    require(msg.sender == oracleAddress, "Not Authorized");
    require(requestsOpen[_id], "Invalid request Id");
    _;
  }
}