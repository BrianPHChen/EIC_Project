pragma solidity ^0.4.17;

import './Token.sol';
import './SafeMath.sol';

contract PrivateSales {
	using SafeMath for uint256;
    address owner;

	EICToken public token;

    uint public startBlock;
	uint public endBlock;
    uint public receivedWei;
    uint public tokenPrice;

    event Bid(address indexed bider, uint256 getToken);

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    function PrivateSales() public {
        owner = msg.sender;
    }

    function setUP(address _tokenAddress, uint blockPeriod) public onlyOwner {
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
    	token.transfer(msg.sender, msg.value.mul(tokenPrice));
        receivedWei.add(msg.value);
        Bid(msg.sender, msg.value.mul(tokenPrice));
    }

    function finalize() public onlyOwner {

    }
}