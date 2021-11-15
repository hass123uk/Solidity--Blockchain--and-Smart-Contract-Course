// SPDX-License-Identifier: MIT

pragma solidity ^0.8.6;

contract FundMe {
    address public owner;

    constructor() {
        owner = msg.sender;
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner, "You must be the deployer of this contract.");
        _;
    }
    
    function withdraw() onlyOwner public view returns (uint256) {
        return 123;
    }
}