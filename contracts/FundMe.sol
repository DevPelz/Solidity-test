// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

import "./PriceConverter.sol";

error NotOwner();

contract FundMe{
    using PriceConverter for uint256;

    uint256 public constant MINIMUM_USD = 50 * 1e18;

    address[] public funders;
    mapping(address => uint256) public addressToAmountFunded;

    AggregatorV3Interface public priceFeed;
    address public immutable i_owner;

    constructor(address priceFeedAddress){
        i_owner = msg.sender;
        priceFeed = AggregatorV3Interface(priceFeedAddress);
    }

    function fund() public payable {
        require(msg.value.getConversionRate(priceFeed) >= MINIMUM_USD, "Didn't send enough!");
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] = msg.value;
    }


    function withdraw() public onlyOwner{
        // require(msg.sender == owner, "Not the owner");

        for(uint256 funderIndex = 0; funderIndex < funders.length; funderIndex = funderIndex + 1){
            address funder= funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }

        funders = new address[](0);

        payable (msg.sender).transfer(address(this).balance);

        bool sendSuccess = payable (msg.sender).send(address(this).balance);
        require(sendSuccess, "Send failed");

    (bool callSuccess,)= payable(msg.sender).call{value: address(this).balance}("");
    require(callSuccess, "Call failed");
    }

    modifier onlyOwner{
        // require(msg.sender == i_owner, "Sender is not owner");
        if(msg.sender != i_owner){revert NotOwner();}
        _;
    }

    receive() external payable{
        fund();
    }

    fallback() external payable {
        fund();
    }
}