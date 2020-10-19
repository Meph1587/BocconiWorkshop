// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/math/SafeMath.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/access/Ownable.sol";


contract TokenVoting is Ownable{
    
    using SafeMath for uint256;
    
    //Datatype Definition
    struct Proposal {
        bool blocked;
        string description;
        address proposer;
        address token;
        uint256 votes_yes;
        uint256 votes_no;
        uint256 closes_on_block;
        bool passed;
    }
    
    // mutable state
    mapping (address => mapping(uint => bool)) has_voted ;
    Proposal[] all_proposals;
    
    
    constructor() public{}
    
    function make_proposal(string calldata description, address token, uint256 duration) external returns(uint256){
        Proposal memory new_proposal = Proposal({
            blocked: false, 
            description: description, 
            proposer:msg.sender,
            token:token, 
            votes_yes:0,
            votes_no:0,
            closes_on_block: block.number + duration,
            passed:false
            
        });
            
        all_proposals.push(new_proposal);
        return all_proposals.length - 1;
    }
    
    function get_proposal(uint256 index) external view returns(Proposal memory){ 
        return all_proposals[index];
    }
    
    function get_proposal_number() external view returns(uint256){ 
        return all_proposals.length;
    }
    
    function block_proposal(uint256 index) external onlyOwner returns(bool){
        Proposal memory proposal = all_proposals[index];
        
        proposal.blocked = true;
        all_proposals[index] = proposal;
        
        return true;
    }
    
    function voting_power(uint256 index) public view returns(uint256){
        Proposal memory proposal = all_proposals[index];
        
        IERC20 token_contract = IERC20(proposal.token);
        uint256 caller_balance = token_contract.balanceOf(msg.sender);
        
        return caller_balance;
    }
    
    function vote_yes(uint256 index) external returns(bool){
        Proposal memory proposal = all_proposals[index];
        
        require(proposal.blocked == false, "Proposal is blocked");
        require(proposal.closes_on_block > block.number, "Proposal expired");
        require(has_voted[msg.sender][index] == false , "User Already voted");
        
        IERC20 token_contract = IERC20(proposal.token);
        uint256 caller_balance = token_contract.balanceOf(msg.sender);
        proposal.votes_yes = proposal.votes_yes.add(caller_balance);
        all_proposals[index] = proposal;
        has_voted[msg.sender][index] = true;
        
        return true;
    }
    
    function vote_no(uint256 index) external returns(bool){
        Proposal memory proposal = all_proposals[index];
        
        require(proposal.blocked == false, "Proposal is blocked");
        require(proposal.closes_on_block > block.number, "Proposal expired");
        require(has_voted[msg.sender][index] == false , "User Already voted");
        
        IERC20 token_contract = IERC20(proposal.token);
        uint256 caller_balance = token_contract.balanceOf(msg.sender);
        proposal.votes_no = proposal.votes_no.add(caller_balance);
        all_proposals[index] = proposal;
        has_voted[msg.sender][index] = true;
        
        return true;
    }
    
    function evaluate_vote(uint256 index) external onlyOwner returns(bool){
         Proposal memory proposal = all_proposals[index];
         
         require(proposal.blocked == false, "Proposal is blocked");
         require(proposal.closes_on_block < block.number, "Proposal is not expired yet");
         
         if (proposal.votes_yes >= proposal.votes_no){
             proposal.passed = true;
         }else{
             proposal.passed = false;
         }
         all_proposals[index] = proposal;
         return true;
    }
    
}