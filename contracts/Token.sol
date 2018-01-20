pragma solidity ^0.4.17;

import './SafeMath.sol';

contract Token {
    using SafeMath for uint256;

    uint256 public totalSupply;
    
    //Functions
    function balanceOf(address _owner) public constant returns (uint256 balance);
    function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
    function transfer(address _to, uint256 _value) public returns (bool success);
    function approve(address _spender, uint256 _value) public returns (bool success);
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
    
    //Events
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}

contract StandardToken is Token {

    uint public lockBlock;
    address owner;

    //Data structures
    mapping (address => uint256) balances;
    mapping (address => mapping (address => uint256)) allowed;

    //Public functions
    function transfer(address _to, uint256 _value) public returns (bool) {
        require(block.number >= lockBlock || msg.sender == owner);
        require(_to != 0x0);
        require(_to != address(this));
        require(balances[msg.sender] >= _value);
        require(balances[_to] + _value >= balances[_to]);

        balances[msg.sender] = balances[msg.sender].sub(_value);
        balances[_to] = balances[_to].add(_value);
        Transfer(msg.sender, _to, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value)
        public
        returns (bool)
    {
        require(block.number >= lockBlock || msg.sender == owner);
        require(_from != 0x0);
        require(_to != 0x0);
        require(_to != address(this));
        require(balances[_from] >= _value);
        require(allowed[_from][msg.sender] >= _value);
        require(balances[_to] + _value >= balances[_to]);

        balances[_from] = balances[_from].sub(_value);
        balances[_to] = balances[_to].add(_value);
        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
        Transfer(_from, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value) public returns (bool) {
        require(_spender != 0x0);
        require(_value == 0 || allowed[msg.sender][_spender] == 0);

        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender)
        constant
        public
        returns (uint256)
    {
        return allowed[_owner][_spender];
    }

    function balanceOf(address _owner) constant public returns (uint256) {
        return balances[_owner];
    }
}

contract EICToken is StandardToken {
    //Token metadata
    string constant public name = "Entertainment Industry Coin";
    string constant public symbol = "EIC";
    uint8 constant public decimals = 18;
    uint constant multiplier = 10 ** uint(decimals);

    function EICToken(
        uint _lockBlockPeriod)
        public
    {
        owner = msg.sender;
        totalSupply = 3125000000 * multiplier;
        balances[owner] = totalSupply;
        lockBlock = block.number + _lockBlockPeriod;
    }

    function distributed() {
        require(msg.sender == owner);
        // only owner can call
    }
}