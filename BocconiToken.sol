// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

// import dependencies with github path
import "https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

/**
    NOTE: GitHub-Web URLs include the branch path '/blob/master' - this needs to be removed when importing files
    ❌ https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol
    ✅ https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
 */

// This contract implements the ERC20 Interface
contract BocconiToken is IERC20 {

    // IMMUTABLE STATE
    string public name;
    string public symbol;
    uint256 public constant decimals = 18;

    // VARIABLE STATE
    uint256 public override totalSupply; // NOTE: public variables can be called as functions `token.totalSupply()`

    mapping(address => uint256) private balances; // NOTE: mappings are read `balances[address]`
    mapping(address => mapping(address => uint256)) allownaces;

    // PUBLIC STATE UPDATE FUNCTIONS

    // called once when contract is created
    constructor(string memory _name, string memory _symbol) {
        name = _name;
        symbol = _symbol;

        //set initial token distribution
        totalSupply = 1000;
        balances[msg.sender] = totalSupply;
    }

    // transfer tokens from msg.sender to reciever
    function transfer(address reciever, uint256 amount)
        public
        override
        returns (bool)
    {
        // call internal method
        _transfer(msg.sender, reciever, amount);
        return true;
    }

    // approve spender to transfer tokens from msg.sender
    function approve(address spender, uint256 amount)
        public
        override
        returns (bool)
    {
        allownaces[msg.sender][spender] = amount;
        return true;
    }

    // transfer approved tokens from "from" to "to"
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public override returns (bool) {
        // check transfer amount is allowed
        require(allownaces[from][msg.sender] > amount, "Allowance to low");

        // call internal method
        _transfer(from, to, amount);

        // decrease allowance
        allownaces[from][msg.sender] -= amount;

        return true;
    }

    // PUBLIC STATE READ FUNCTIONS

    // get the token balance of "owner"
    function balanceOf(address owner) public view override returns (uint256) {
        return balances[owner];
    }

    // get how many tokens an "owner" approved to be spent by "spender"
    function allowance(address owner, address spender)
        public
        view
        override
        returns (uint256)
    {
        return allownaces[owner][spender];
    }

    // INTERNAL STATE UPDATE FUNCTIONS

    // decrease "from" balance and increase "to" balance
    function _transfer(
        address from,
        address to,
        uint256 amount
    ) internal returns (bool) {
        // check "from" has enought tokens
        require(balances[from] > amount, "Balance is to low");

        // update balances
        balances[from] = balances[from] - amount;
        balances[to] = balances[to] + amount;

        return true;
    }
}
