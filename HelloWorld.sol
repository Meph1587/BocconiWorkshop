// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract HelloWorld {
    //state
    string private _hello_world = "Hello World!";

    //state update functions
    function setHelloWorld(string memory new_hello_wolrd)
        public
        returns (bool)
    {
        _hello_world = new_hello_wolrd;
        return true;
    }

    //gas-free readonly function
    function getHelloWorld() public view returns (string memory) {
        return _hello_world;
    }
}
