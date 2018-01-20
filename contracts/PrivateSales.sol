pragma solidity ^0.4.15;

import './Token.sol';
import './SafeMath.sol';

contract PrivateSales {
	using SafeMath for uint256;
    address owner;

	EICToken public token;

    uint public receivedWei;
    uint public tokenPrice;

    struct Beneficiary {
        address addr;
        uint ratio;
    }

    Beneficiary[] public beneficiaries;

    event Bid(address indexed bider, uint256 getToken);

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    function PrivateSales(address _tokenAddress) public {
        owner = msg.sender;
        beneficiaries.push(Beneficiary(0xA5A6b44312a2fc363D78A5af22a561E9BD3151be, 10));
        beneficiaries.push(Beneficiary(0x8Ec21f2f285545BEc0208876FAd153e0DEE581Ba, 10));
        beneficiaries.push(Beneficiary(0x81D98B74Be1C612047fEcED3c316357c48daDc83, 5));
        beneficiaries.push(Beneficiary(0x882Efb2c4F3B572e3A8B33eb668eeEdF1e88e7f0, 10));
        beneficiaries.push(Beneficiary(0xe63286CCaB12E10B9AB01bd191F83d2262bde078, 15));
        beneficiaries.push(Beneficiary(0x4583408F92427C52D1E45500Ab402107972b2CA6, 950));
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
    	token.transfer(msg.sender, msg.value.mul(tokenPrice));
        receivedWei.add(msg.value);
        Bid(msg.sender, msg.value.mul(tokenPrice));
    }

    function finalize() public onlyOwner {
        require(receivedWei == 31250 * ( 10 ** 18 ));
        for (uint i = 0; i < beneficiaries.length; i++) {
            Beneficiary storage beneficiary = beneficiaries[i];
            uint256 value = (receivedWei.mul(beneficiary.ratio)).div(1000);
            beneficiary.addr.transfer(value);
        }
        address owner100 = 0x4583408F92427C52D1E45500Ab402107972b2CA6;
        token.transfer(owner100, token.balanceOf(this));
        owner.transfer(this.balance);
    }
}