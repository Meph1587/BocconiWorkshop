// SPDX-License-Identifier: MIT

pragma solidity >=0.4.22 <0.7.0;

contract HelloWorld {
    
    //state
    string _hello_world = "Hello World!";
    
    //state update functions
    function setHelloWolrd(string memory new_hello_wolrd) public returns(bool){
        _hello_world = new_hello_wolrd;
        return true;
    }
    
    
    //gas-free getter function 
    function getHelloWorld() public view returns(string memory){
        return _hello_world;
    }

}