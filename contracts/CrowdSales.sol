pragma solidity ^0.4.17;

import './Token.sol';
import './SafeMath.sol';

contract CrowdSales{
	using SafeMath for uint256;

	EICToken public token;

    uint public startBlock;
    uint public receivedWei;
    uint public tokenPrice;

    event Bid(address indexed bider, uint256 getToken);

    function setUP(address _tokenAddress, uint blockPeriod) {
    	token = EICToken(_tokenAddress);
    	startBlock = block.number;
    	endBlock = startBlock + blockPeriod;
    	tokenPrice = 15000;
    }

    function () public payable {
    	bid();
    }

    function bid()
    	public
    	payable
    {	
    	require(startBlock != 0);
    	require(block.number <= endBlock);
    	require(token.balanceOf(msg.sender).add(msg.value.mul(tokenPrice)) >= (5 ether).mul(tokenPrice));
    	require(token.balanceOf(msg.sender).add(msg.value.mul(tokenPrice)) <= (200 ether).mul(tokenPrice));
		token.balanceOf(msg.sender) = token.balanceOf(msg.sender).add(msg.value.mul(tokenPrice))
    	receivedWei.add(msg.value);
		Bid(msg.sender, msg.value.mul(tokenPrice));
    }

    function finalize() {
    	require(block.number > endBlock);
    	
    }
}