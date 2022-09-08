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
abstract contract TokenTemplate is IERC20 {

    // IMMUTABLE STATE

    // VARIABLE STATE

    // PUBLIC STATE UPDATE FUNCTIONS

    // called once when contract is created
    constructor(string memory _name, string memory _symbol) {}

    // transfer tokens from msg.sender to reciever
    function transfer(address reciever, uint256 amount)
        public
        override
        returns (bool)
    {}

    // approve spender to transfer tokens from msg.sender
    function approve(address spender, uint256 amount)
        public
        override
        returns (bool)
    {}

    // transfer approved tokens from "from" to "to"
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public override returns (bool) {}

    // PUBLIC STATE READ FUNCTIONS

    // get the token balance of "owner"
    function balanceOf(address owner) public view override returns (uint256) {}

    // get how many tokens an "owner" approved to be spent by "spender"
    function allowance(address owner, address spender)
        public
        view
        override
        returns (uint256)
    {}

    // INTERNAL STATE UPDATE FUNCTIONS

    // decrease "from" balance and increase "to" balance
    function _transfer(
        address from,
        address to,
        uint256 amount
    ) internal returns (bool) {}
}
