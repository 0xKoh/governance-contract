// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/test.sol";
import "../src/Governance.sol";

contract GovernanceTest is Test {

    Governance gvContract;

    struct context {
        address sender;
        string content;
    }
    
    function setUp() public {
        gvContract = new Governance("Governance", "1");
    }

    function test_Propose()
        public
    {
        // gvContract.proposing();
        // gvContract.voting(1, true);
    }

    function test_GetApproval() 
    view
    public
    returns(uint256)
    {
        return gvContract.getApproval(1);
    }

}