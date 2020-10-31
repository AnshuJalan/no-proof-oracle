pragma solidity ^0.5.0;

import './EternalStorage.sol';

contract Oracle is EternalStorage{

  event NewRequest(uint256 id, uint256 apiId);
  event DataSubmitted(uint256 id, uint256 data);

  function getRequestedData(uint256 _apiId) external returns(uint256){
    uint256 _id = getUintVar(keccak256('requestCount'));
    pendingRequests[_id] = msg.sender;
    setUintVar(keccak256('requestCount'), _id + 1);
    emit NewRequest(_id, _apiId);
    return _id;
  }


  /**
  * @dev Can add staking restriction here.
  * Only the staked accounts can submit the data.
  */
  function submitRequestedData(uint256 _id, uint256 _data) external {
    require(pendingRequests[_id] != address(0), "Invalid id");
    address _user = pendingRequests[_id];
    (bool result, ) = _user.call(abi.encodeWithSignature("requestCallback(uint256,uint256)", _id, _data));
    require(result, "Low level call failed!");
    delete pendingRequests[_id];
    emit DataSubmitted(_id, _data);
  }
}