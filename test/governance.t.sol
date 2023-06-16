// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Governance {
    address public owner;
    mapping(address => bool) public votes;

    constructor() {
        owner = msg.sender;
    }
}