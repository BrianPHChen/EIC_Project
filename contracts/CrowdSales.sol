pragma solidity ^0.4.15;

import './EICToken.sol';

contract CrowdSales {
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

    function CrowdSales(address _tokenAddress) public {
        owner = msg.sender;
        beneficiaries.push(Beneficiary(0xA5A6b44312a2fc363D78A5af22a561E9BD3151be, 10));
        beneficiaries.push(Beneficiary(0x8Ec21f2f285545BEc0208876FAd153e0DEE581Ba, 10));
        beneficiaries.push(Beneficiary(0x81D98B74Be1C612047fEcED3c316357c48daDc83, 5));
        beneficiaries.push(Beneficiary(0x882Efb2c4F3B572e3A8B33eb668eeEdF1e88e7f0, 10));
        beneficiaries.push(Beneficiary(0xe63286CCaB12E10B9AB01bd191F83d2262bde078, 15));
        beneficiaries.push(Beneficiary(0xCcab73497D432a07705DCca58358e00F87bA4CD5, 285));
        beneficiaries.push(Beneficiary(0x4583408F92427C52D1E45500Ab402107972b2CA6, 665));
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
    	require(block.number <= token.lockBlock());
        require(receivedWei <= 62500 * ( 10 ** 18 ));
    	require(token.balanceOf(msg.sender) + (msg.value * tokenPrice) >= (5 * (10 ** 18)) * tokenPrice);
    	require(token.balanceOf(msg.sender) + (msg.value * tokenPrice) <= (200 * (10 ** 18)) * tokenPrice);
        token.transfer(msg.sender, msg.value * tokenPrice);
        receivedWei += msg.value;
        Bid(msg.sender, msg.value * tokenPrice);
    }

    function finalize() public onlyOwner {
    	require(block.number > token.lockBlock() || receivedWei == 62500 * ( 10 ** 18 ));
        for (uint i = 0; i < beneficiaries.length; i++) {
            Beneficiary storage beneficiary = beneficiaries[i];
            uint256 value = (receivedWei * beneficiary.ratio)/(1000);
            beneficiary.addr.transfer(value);
        }
        if (token.balanceOf(this) > 0) {
            uint256 remainingToken = token.balanceOf(this);
            address owner30 = 0xCcab73497D432a07705DCca58358e00F87bA4CD5;
            address owner70 = 0x4583408F92427C52D1E45500Ab402107972b2CA6;

            token.transfer(owner30, (remainingToken * 30)/(100));
            token.transfer(owner70, (remainingToken * 70)/(100));
        }
        owner.transfer(this.balance);
    }
}