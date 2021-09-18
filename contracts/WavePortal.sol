// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import 'hardhat/console.sol';

contract WavePortal {
    uint totalWaves;
    uint private seed;

    event NewWave(address indexed from, uint timestamp, string message);

    struct Wave {
        address waver;
        string message;
        uint timestamp;
    }

    Wave[] waves;

    mapping(address => uint) public lastWavedAt;

    constructor() payable {
        console.log('Yo yo, I am a contract and I am smart');
    }

    function wave(string memory _message) public {

        require(lastWavedAt[msg.sender] + 15 minutes < block.timestamp, "Wait 15 minutes");
        lastWavedAt[msg.sender] = block.timestamp;

        totalWaves += 1;
        console.log('%s is waved with %s', msg.sender, _message);
        waves.push(Wave(msg.sender, _message, block.timestamp));

        uint randomNumber = (block.difficulty + block.timestamp + seed) % 100;
        console.log("Random # generated: %s", randomNumber);

        seed = randomNumber;

        // Give ether to lucky waver!
        if(randomNumber == 42) {
            uint prizeAmount = 0.0001 ether;
            console.log("%s won 0.0001 ether!", msg.sender);

            require(prizeAmount <= address(this).balance, 'Trying to withraw more money than the contract has.');
            (bool success,) = (msg.sender).call{value: prizeAmount}('');
            require(success, 'Failed to withraw money from contract.');
        }

        emit NewWave(msg.sender, block.timestamp, _message);
    }

    function getAllWaves() view public returns (Wave[] memory) {
        return waves;
    }

    function getTotalWaves() view public returns (uint) {
        console.log('We have %d total waves', totalWaves);
        return totalWaves;
    }
}

