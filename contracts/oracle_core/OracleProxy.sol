pragma solidity ^0.5.0;

import './EternalStorage.sol';

contract OracleProxy is EternalStorage {

  event NewRequestFromUser(uint256 id, uint256 apiId);
  event DataSubmitted(uint256 id, uint256 data);

  constructor(address _implAddress) public {
    setAddressVar(keccak256('owner'), msg.sender);
    setAddressVar(keccak256('oracleAddress'), _implAddress);
  }

  function updateImplementation(address _newImpl) external {
    require(msg.sender == getAddressVar(keccak256('owner')));
    setAddressVar(keccak256('oracleAddress'), _newImpl);
  }

  function() external payable {
    address _oracleImpl = getAddressVar(keccak256('oracleAddress'));

    assembly {
      let ptr := mload(0x40)
      calldatacopy(ptr, 0, calldatasize)
      let result := delegatecall(gas, _oracleImpl, ptr, calldatasize, 0, 0)
      let size := returndatasize
      returndatacopy(ptr, 0, size)

      switch result
        case 0 { revert(ptr, size) }
        default { return(ptr, size) }
    }
  }
}