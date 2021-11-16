// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

contract FundMe {
    address payable owner;
    mapping(address => uint256) public addressToAmountMap;

    constructor() {
        owner = payable(msg.sender);
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner, "You must be the deployer of this contract.");
        _;
    }

    function withdraw() payable onlyOwner public {
        owner.transfer(address(this).balance);
    }

    function withdrawWithCall() payable onlyOwner public {
        (bool sent,) = owner.call{value: address(this).balance}("");
        require(sent, "Failed to send Ether");
    }

    function deposit() payable public {
        require(msg.value >= 5, "Value send me be greater then 5 wei");

        addressToAmountMap[msg.sender] += msg.value;
    }
}