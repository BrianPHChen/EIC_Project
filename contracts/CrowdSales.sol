pragma solidity ^0.4.17;

import './Token.sol';
import './SafeMath.sol';

contract CrowdSales {
	using SafeMath for uint256;
    address owner;

	EICToken public token;

    uint public receivedWei;
    uint public tokenPrice;

    struct Beneficiary {
        address addr;
        uint256 ratio;
    }

    Beneficiary[] public beneficiaries;

    event Bid(address indexed bider, uint256 getToken);

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    function CrowdSales() public {
        owner = msg.sender;
        beneficiaries.push(Beneficiary(0xA5A6b44312a2fc363D78A5af22a561E9BD3151be, 10));
        beneficiaries.push(Beneficiary(0x8Ec21f2f285545BEc0208876FAd153e0DEE581Ba, 10));
        beneficiaries.push(Beneficiary(0x81D98B74Be1C612047fEcED3c316357c48daDc83, 5));
        beneficiaries.push(Beneficiary(0x882Efb2c4F3B572e3A8B33eb668eeEdF1e88e7f0, 10));
        beneficiaries.push(Beneficiary(0xe63286CCaB12E10B9AB01bd191F83d2262bde078, 15));
        beneficiaries.push(Beneficiary(0xCcab73497D432a07705DCca58358e00F87bA4CD5, 285));
        beneficiaries.push(Beneficiary(0x4583408F92427C52D1E45500Ab402107972b2CA6, 665));
    }

    function setUP(address _tokenAddress) public onlyOwner {
    	token = EICToken(_tokenAddress);
    	tokenPrice = 15000;
    }

    function () public payable {
    	bid();
    }

    function bid()
    	public
    	payable
    {
    	require(tokenPrice != 0);
    	require(block.number <= token.lockBlock());
        require(receivedWei <= 62500 * ( 10 ** 18 ));
    	require(token.balanceOf(msg.sender).add(msg.value.mul(tokenPrice)) >= uint256(5 * (10 ** 18)).mul(tokenPrice));
    	require(token.balanceOf(msg.sender).add(msg.value.mul(tokenPrice)) <= uint256(200 * (10 ** 18)).mul(tokenPrice));
        token.transfer(msg.sender, msg.value.mul(tokenPrice));
        receivedWei.add(msg.value);
        Bid(msg.sender, msg.value.mul(tokenPrice));
    }

    function finalize() onlyOwner {
    	require(block.number > token.lockBlock() || receivedWei == 62500 * ( 10 ** 18 ));
        for (uint i = 0; i < beneficiaries.length; i++) {
            Beneficiary storage beneficiary = beneficiaries[i];
            uint256 value = (receivedWei.mul(beneficiary.ratio)).div(1000);
            beneficiary.addr.transfer(value);
        }
        if (token.balanceOf(this) > 0) {
            uint256 remainingToken = token.balanceOf(this);
            address owner30 = 0xCcab73497D432a07705DCca58358e00F87bA4CD5;
            address owner70 = 0x4583408F92427C52D1E45500Ab402107972b2CA6;

            token.transfer(owner30, remainingToken.mul(30).div(100));
            token.transfer(owner70, remainingToken.mul(70).div(100));
        }
        owner.transfer(this.balance);
    }
}