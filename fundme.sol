// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract FundMe {
    address payable owner;
    mapping(address => uint256) public addressToAmountMap;
    AggregatorV3Interface internal priceFeed;

    /**
     * Network: Rinkby Test net
     * Aggregator: ETH/USD
     * Address: 0x8A753747A1Fa494EC906cE90E9f37563A8AF630e
     * https://docs.chain.link/docs/ethereum-addresses/
     */
     address internal priceFeedAddress = 0x8A753747A1Fa494EC906cE90E9f37563A8AF630e;

    constructor() {
        owner = payable(msg.sender);
        priceFeed = AggregatorV3Interface(priceFeedAddress);
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner, "You must be the deployer of this contract.");
        _;
    }

    function withdraw() public payable onlyOwner {
        owner.transfer(address(this).balance);
    }

    function fund() public payable {
        uint256 minUSD = 5 * (10 ** 18);
        require(getConversionRate(msg.value) >= minUSD, "Must send at least 5 USD worth of ETHER");

        addressToAmountMap[msg.sender] += msg.value;
    } 
    
    function getConversionRate(uint256 weiAmount) public view returns (uint256){
        uint256 ethPrice = getPrice() *  10000000000;
        uint256 ethAmountInUsd = (ethPrice * weiAmount) / 1000000000000000000;
        return ethAmountInUsd;
    }
    
    function getPrice() public view returns (uint256) {
        (,int price,,,) = priceFeed.latestRoundData();
        return uint256(price);
    }
}