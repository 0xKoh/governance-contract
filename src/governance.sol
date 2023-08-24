// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "@openzeppelin/utils/cryptography/EIP712.sol";
import "@openzeppelin/utils/cryptography/ECDSA.sol";

contract Governance is EIP712 {

    struct proposal {
        string name;
        string content;
        address proposer;
        bool isProposed;
        uint256 population;
        uint256 approval;
    }

    // signature message typed struct.
    struct message {
        uint256 id;
        address sender;
        string contents;
    }

    // Proposal number.
    mapping(uint256 => proposal) public proposals;

    // Vote status.
    mapping(uint256 => mapping(address => bool)) public votes;


    constructor(string memory _name, string memory _version) 
        EIP712(_name, _version) {
    }


    event Proposing(
        address indexed _proposer,
        string _name,
        string _content
    );

    event Voting(
        address indexed _voter,
        uint256 indexed _id,
        bool _approval
    ); 


    // set proposal contents.
    function _setStatus (
        uint256 _id, 
        string calldata _name, 
        string calldata _content,
        address _msgSender
    ) internal {
        proposal memory cProposal = proposals[_id];

        // State update process.
        cProposal.name = _name;
        cProposal.content = _content;
        cProposal.proposer = _msgSender;
        cProposal.isProposed = true;

        proposals[_id] = cProposal;
    }


    // validate the signature and Get sender address.
    function _verify (
        uint256 _id,
        address _sender,
        string calldata _contents,
        string calldata _method,
        bytes calldata _signature
    ) internal view returns (address) {
        bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(
            keccak256(bytes(_method)),
            _id,
            _sender,
            keccak256(bytes(_contents))
        )));
        return ECDSA.recover(digest, _signature);
    }


    function proposing(
        uint256 _id,  
        address calldata _sender,
        string calldata _name,
        string calldata _contents,
        bytes calldata _signature
    ) external {
        if(proposals[_id].isProposed) revert("Already proposed");
        address _msgSender = _verify(_id, _sender, _contents, _signature, "propose(uint256 _id, address _sender, string _contents)");
        _setStatus(
            _id,
            _name,
            _contents,
            _msgSender
        );
        emit Proposing(_msgSender, _name, _contents);
    }


    // voting by user.
    function voting(
        uint256 _id,
        address _sender,
        string calldata _contents,
        bool _approval,
        bytes calldata _signature
    ) external {
        address _msgSender = _verify(_id, _sender, _contents, _signature, "voting(uint256 _id, bool _approval)");
        require(!proposals[_id].isProposed, "Undefined the proposal");
        require(!isVoted(_id, _msgSender), "Already voted");

        votes[_id][_msgSender] = true;
        proposals[_id].population += 1;

        if(_approval) {
            proposals[_id].approval += 1;
            return;
        }
        emit Voting(_msgSender, _id, _approval);
    }
    

    // Get the Proposal.
    function getProposal(uint256 _id) external view returns(proposal memory) {
        require(proposals[_id].isProposed, "Undefined the proposal");
        return proposals[_id];
    }

    function getPopulation(uint256 _id) external view returns(uint256) {
        require(proposals[_id].isProposed, "Undefined the proposal");
        return proposals[_id].population;
    }


    function getApproval(uint256 _id) external view returns(uint256) {
        require(proposals[_id].isProposed, "Undefined the proposal");
        return proposals[_id].approval;
    }

    function isVoted(uint256 _id, address _msgSender) public view returns(bool) {
        return votes[_id][_msgSender];
    }
}