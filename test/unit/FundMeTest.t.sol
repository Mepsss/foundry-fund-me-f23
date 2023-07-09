//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;

    //create fake new Address to send all the transactions from
    address USER = makeAddr("user");
    uint256 constant SEND_VALUE = 0.1 ether;
    uint256 constant STARTING_BALANCE = 10 ether;
    uint256 constant GAS_PRICE = 1;

    function setUp() external {
        //fundMe = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);  old inefficient way
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(USER, STARTING_BALANCE);
    }

    function testMinimumDollarIsFive() public {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testOwnerIsMsgSender() public {
        assertEq(fundMe.getOwner(), msg.sender);
    }

    function testPriceFeedVersionIsAccurate() public {
        uint256 version = fundMe.getVersion();
        assertEq(version, 4);
    }

    function testFundFailsWithoutEnoughETH() public {
        vm.expectRevert(); //next line should revert
        fundMe.fund(); //sending 0 value on purpose, less than minimum -> should revert
    }

    function testFundUpdatesFundedDataStructure() public {
        vm.prank(USER); //pretend to be USER for next tx
        fundMe.fund{value: SEND_VALUE}(); //10ETH >> 5$
        uint256 amountFunded = fundMe.getAddressToAmountFunded(USER);
        assertEq(amountFunded, SEND_VALUE);
    }

    function testAddsFunderToArrayOfFunders() public {
        vm.prank(USER); //pretend to be USER for next tx
        fundMe.fund{value: SEND_VALUE}(); //0.1 > 5$

        address funder = fundMe.getFunders(0);
        assertEq(funder, USER); //check if funder is in the array
    }

    modifier funded() {
        vm.prank(USER); //pretend to be USER for next tx
        fundMe.fund{value: SEND_VALUE}(); //0.1 > 5$
        _;
    }

    function testOnlyOwnerCanWithdraw() public funded {
        vm.expectRevert(); //next line should revert
        vm.prank(USER); //pretend to be USER, funding guy shouldnt be able to withdraw
        fundMe.withdraw(); //should revert
    }

    function testWithDrawWithASingleFunder() public funded {
        //Arrange
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        //Act (what we are testing)
        vm.prank(fundMe.getOwner()); //pretend to be owner
        fundMe.withdraw();

        //Assert
        uint256 endingOwnerBalance = fundMe.getOwner().balance;
        uint256 endingFundMeBalance = address(fundMe).balance;
        assertEq(endingFundMeBalance, 0);
        assertEq(
            startingFundMeBalance + startingOwnerBalance,
            endingOwnerBalance
        );
    }

    function testWithdrawFromMultipleFunders() public funded {
        uint160 numberOfFunders = 10; //160 is the same as size of a
        uint160 startingFunderIndex = 1; //dont send to 0 there are sanity checks and stuff there

        for (uint160 i = startingFunderIndex; i < numberOfFunders; i++) {
            //Srrange
            //prank+deal = hoax
            hoax(address(i), SEND_VALUE);
            fundMe.fund{value: SEND_VALUE}();

            //Sct
            uint256 startingOwnerBalance = fundMe.getOwner().balance;
            uint256 startingFundMeBalance = address(fundMe).balance;

            vm.prank(fundMe.getOwner()); //pretend to be owner
            fundMe.withdraw();

            //Assert
            assert(address(fundMe).balance == 0); //make sure everything is withdrawn
            assert(
                startingFundMeBalance + startingOwnerBalance ==
                    fundMe.getOwner().balance
            );
        }
    }

    function testWithdrawFromMultipleFundersCheaper() public funded {
        uint160 numberOfFunders = 10; //160 is the same as size of a
        uint160 startingFunderIndex = 1; //dont send to 0 there are sanity checks and stuff there

        for (uint160 i = startingFunderIndex; i < numberOfFunders; i++) {
            //Srrange
            //prank+deal = hoax
            hoax(address(i), SEND_VALUE);
            fundMe.fund{value: SEND_VALUE}();

            //Sct
            uint256 startingOwnerBalance = fundMe.getOwner().balance;
            uint256 startingFundMeBalance = address(fundMe).balance;

            vm.prank(fundMe.getOwner()); //pretend to be owner
            fundMe.cheaperWithdraw();

            //Assert
            assert(address(fundMe).balance == 0); //make sure everythign is withdrawn
            assert(
                startingFundMeBalance + startingOwnerBalance ==
                    fundMe.getOwner().balance
            );
        }
    }
}
