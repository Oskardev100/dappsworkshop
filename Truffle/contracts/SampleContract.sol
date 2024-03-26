// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

contract SampleContract {
    address public manager;
    address payable[] public players;
    
    constructor() {
        manager = msg.sender;
    }
    
    function enter() public payable {
        require(msg.value > .001 ether);
        players.push(payable(msg.sender));
    }
    
    function getPlayers() public view returns (address payable[] memory) {
        return players;
    }
} 