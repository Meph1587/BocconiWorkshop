// SPDX-License-Identifier: MIT

pragma solidity >=0.4.22 <0.7.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/math/SafeMath.sol";

contract BocconiToken is IERC20{
    
    using SafeMath for uint256;
    
    //mutable state
    mapping (address => uint256) private balances;
    mapping (address => mapping (address => uint256)) private allowances;
    uint256 private _totalSupply;
    
    //fixed state
    string _name;
    string _symbol;
    uint256 _decimals;
    
    //Notification for transfers
    event Transfer(address indexed from, address indexed to, uint256 value);
    
    
    constructor(string memory name, string memory symbol, uint256 decimals) public{
        _name = name;
        _symbol = symbol;
        _decimals = decimals;
        
        //create initial token distribution
        balances[msg.sender] = 1000;
        _totalSupply = 1000;
    }
    
    
    function totalSupply() override external view returns (uint256){
        return _totalSupply;
    }
    
    function balanceOf(address account) override external view returns (uint256){
        return balances[account];
    }
    
    function transfer(address recipient, uint256 amount) override external returns (bool){
        require(balances[msg.sender] >= amount, "Sender has not enougth Tokens");
        
        balances[msg.sender] = balances[msg.sender].sub(amount);
        balances[recipient] = balances[recipient].add(amount);
        
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }
    
    function allowance(address owner, address spender) override external view returns (uint256){
        return allowances[owner][spender];
    }
    
    function approve(address spender, uint256 amount) override external returns (bool){
        require(balances[msg.sender] >= amount, "Sender has not enougth Tokens");
        allowances[msg.sender][spender] = amount;
        
        return true;
    }
    
    function transferFrom(address sender, address recipient, uint256 amount) override external returns (bool){
        require(balances[sender] >= amount, "Sender has not enougth Tokens");
        require(allowances[sender][msg.sender] >= amount, "Sender is not allowed to move this amount");
        
        balances[sender] = balances[sender].sub(amount);
        balances[recipient] = balances[recipient].add(amount);
        allowances[sender][msg.sender] = 0;
        
        emit Transfer(sender, recipient, amount);
        return true;
    }


    
}