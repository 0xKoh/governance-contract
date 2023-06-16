// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/token/ERC20/IERC20.sol";
import "@openzeppelin/utils/cryptography/EIP712.sol";

contract Governance is EIP712 {
    
    address public owner;
    mapping(address => bool) public votes;

    constructor(string memory _name, string memory _version) EIP712(_name, _version) {
        owner = msg.sender;
    }
}