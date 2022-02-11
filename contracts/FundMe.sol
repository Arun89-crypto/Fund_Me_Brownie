// SPDX-License-Identifier: MIT

pragma solidity ^0.6.6;

// importing the chainlink code for getting the price feed
// we can also copy the original code but the import statement will also work fine
import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";
// using safe math to check for any integer overflows or underflows
import "@chainlink/contracts/src/v0.6/vendor/SafeMathChainlink.sol";

// Here we will make a contract that will accept payment
contract FundMe {
    using SafeMathChainlink for uint256;

    // we made a mapping to get the amount sent to us by a particular address
    mapping(address => uint256) public addressToAmountFunded;
    address[] public funders; // array to keep track of all addresses
    address public owner;
    AggregatorV3Interface public priceFeed;

    // Constructor
    constructor(address _priceFeed) public {
        priceFeed = AggregatorV3Interface(_priceFeed);
        owner = msg.sender;
    }

    // if we declare our function as payable it means that we can accept it as payment
    function fund() public payable {
        // $50
        uint256 minimumUSD = 50 * (10**18); // WEI
        require(
            getConversionRate(msg.value) >= minimumUSD,
            "You need to spend more eth"
        ); // This will check for the condition here and revert if its not true
        // This code adds amount sent by address in the mapping
        addressToAmountFunded[msg.sender] += msg.value;
        // pushing address to funders array
        funders.push(msg.sender);
    }

    function getVersion() public view returns (uint256) {
        return priceFeed.version();
    }

    // This will return the latest price of etherium
    function getPrice() public view returns (uint256) {
        // values between the commas will be ignored
        (, int256 answer, , , ) = priceFeed.latestRoundData();
        return uint256(answer * 10000000000);
        // returns usd value in 18 decimals
    }

    // 1 Eth = 1000000000 GWEI = 10^9 GWEI
    function getConversionRate(uint256 ethAmount)
        public
        view
        returns (uint256)
    {
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1000000000000000000;
        return ethAmountInUsd;
        // This will give us the value in USD = ethAmountInUsd * 10^-10 * 1 GWEI
    }

    function getEntranceFee() public view returns (uint256) {
        // minimum USD
        uint256 minimumUSD = 50 * 10**18;
        uint256 price = getPrice();
        uint256 precision = 1 * 10**18;
        return (minimumUSD * precision) / price;
    }

    // Adding modifier to check if a owner is accessing a particular function or not
    modifier onlyOwner() {
        require(msg.sender == owner, "You are not allowed to withdraw");
        _;
    }

    // Withdrawing the amount sent to the contract
    function withdraw() public payable onlyOwner {
        msg.sender.transfer(address(this).balance);
        // for loop to reset the amount when all tokens withdrawn
        for (
            uint256 fundersIndex = 0;
            fundersIndex < funders.length;
            fundersIndex++
        ) {
            address funder = funders[fundersIndex];
            addressToAmountFunded[funder] = 0;
        }
        funders = new address[](0); // resetting the array
    }
}
