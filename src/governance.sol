// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "@openzeppelin/token/ERC20/IERC20.sol";
import "@openzeppelin/utils/cryptography/EIP712.sol";
import "@diamond-standard/diamond.sol";
import "@openzeppelin/utils/cryptography/ECDSA.sol";
import "@openzeppelin/utils/Context.sol";

contract Governance is EIP712 {

    struct proposal {
        string name;
        string content;
        address proposer;
        bool isProposed;
        uint256 population;
        uint256 approval;
    }

    // context of a signature.
    struct context {
        address sender;
        string parameters;
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


    // Vote for a proposal.
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
    function verify (
        bytes calldata _signature,
        string memory _method,
        context calldata _calldata
    ) internal pure returns (address) {
        bytes32 digest = keccak256(abi.encode(
            keccak256(bytes(_method)),
            _calldata.sender,
            keccak256(bytes(_calldata.parameters))
        ));
        return ECDSA.recover(digest, _signature);
    }


    function proposing(
        uint256 _id, 
        string calldata _name, 
        string calldata _content,
        context calldata _calldata,
        bytes calldata _signature
    ) 
        external
    {
        require(!proposals[_id].isProposed, "Already proposed");
        address _msgSender = verify(_signature, "proposing(uint256 _id, string _name, string _content)", _calldata);
        _setStatus(
            _id,
            _name,
            _content,
            _msgSender
        );
        emit Proposing(_msgSender, _name, _content);
    }


    // voting by user.
    function voting(
        uint256 _id,
        bool _approval,
        context calldata _calldata,
        bytes calldata _signature
    ) external {
        address _msgSender = verify(_signature, "voting(uint256 _id, bool _ballot)", _calldata);
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