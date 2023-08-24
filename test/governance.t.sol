// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/test.sol";
import "../src/Governance.sol";

contract GovernanceTest is Test {

    Governance _gvContract;

    struct Context {
        address sender;
        string content;
    }
    
    function setUp() public {
        gvContract = new Governance("Governance", "1");
    }

    function testPropose()
        public
    {
        // gvContract.proposing();
        // gvContract.voting(1, true);
    }

    function testGetApproval() 
        view
        public
    returns(uint256)
    {
        return gvContract.getApproval(1);
    }

}