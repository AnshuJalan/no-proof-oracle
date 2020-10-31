pragma solidity ^0.5.0;

contract EternalStorage {
  mapping(bytes32 => address) addressVars;
  mapping(bytes32 => uint256) uintVars;

  function getAddressVar(bytes32 _key) internal view returns(address){
    return addressVars[_key];
  }

  function getUintVar(bytes32 _key) internal view returns(uint256) {
    return uintVars[_key];
  }

  function setAddressVar(bytes32 _key, address _data) internal {
    addressVars[_key] = _data;
  }

  function setUintVar(bytes32 _key, uint256 _data) internal {
    uintVars[_key] = _data;
  }
}