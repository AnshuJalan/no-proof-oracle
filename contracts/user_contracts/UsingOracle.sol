pragma solidity ^0.5.0;

contract UsingOracle {

  address private owner;
  address private oracleAddress;

  mapping(uint256 => bool) public requestsOpen;

  //Native to this implementation. Records the latest reponse for a particular requestId;
  mapping(uint256 => uint256) public latestResponse;

  event NewOracleAddress(address newOracleAddress);
  event NewRequest(uint256 requestId, uint256 requestedApiId);
  event ReceivedData(uint256 requestId, uint256 data);

  constructor(address _oracleAddress) public {
    oracleAddress = _oracleAddress;
    owner = msg.sender;
  }

  function updateOracleAddress(address _newOracleAddress) external onlyOwner{
    oracleAddress = _newOracleAddress;
  }

  /**
  * @param _apiId is native to this implementation.
  * Replace it with hash for a generic usecase.
  * @dev Data is the Eth price in USD for this implementation.
  * It could be anything generic too, as long as the data response in a integer.
  */
  function requestData(uint256 _apiId) public returns(uint256) {
    uint256 _id;
    address _oracleImpl = oracleAddress;
    bytes memory _calldata = abi.encodeWithSignature('getRequestedData(uint256)', _apiId);

    assembly {
      let result := call(gas, _oracleImpl, 0, add(_calldata, 32), mload(_calldata), 0, 0)
      let ptr := mload(0x40)
      returndatacopy(ptr, 0, returndatasize)
      _id := mload(ptr)
    }

    requestsOpen[_id] = true;
    emit NewRequest(_id, _apiId);

    return _id;
  }

  /**
  * @dev Access using low level call from the oracle
  */
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