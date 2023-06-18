// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/token/ERC20/IERC20.sol";
import "@openzeppelin/utils/cryptography/EIP712.sol";
import "@diamond-standard/diamond.sol";
import "@openzeppelin/utils/cryptography/ECDSA.sol";
import "@openzeppelin/utils/Context.sol";

contract Governance is Context, EIP712 {

    struct proposal {
        string name;
        bytes32 content;
        bool isProposed;
        uint256 population;
        uint256 approval;
    }

    // Proposal number.
    mapping(uint256 => proposal) public proposals;

    mapping(uint256 => mapping(address => bool)) public votes;

    constructor(string memory _name, string memory _version) EIP712(_name, _version) {
        
    }

    // Vote for a proposal.

    function proposing(uint256 _num, string memory _name, bytes32 _content) external {
        require(proposals[_num].isProposed, "Already proposed");
        proposal memory cProposal = proposals[_num];
        cProposal.name = _name;
        cProposal.content = _content;
        cProposal.isProposed = true;
        proposals[_num] = cProposal;
    }

    // voting by user.

    function voting(uint256 _num, bool _bool) external {
        require(proposals[_num].isProposed, "Undefined the proposal");
        require(votes[_num][_msgSender()], "Already voted");

        votes[_num][_msgSender()] = true;

        if(_bool) {
            proposals[_num].approval += 1;
        } 
    }


}