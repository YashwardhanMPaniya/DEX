// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import "hardhat/console.sol";
import "./ExampleExternalContract.sol";

contract Staker {
    ExampleExternalContract public exampleExternalContract;

    //state variable
    mapping(address => uint256) public balances;
    uint256 public constant threshold = 1 ether;
    //uint256 public totalAmount;
    uint256 public deadline = block.timestamp + 72 hours;

    bool public canWithdraw = false;

    //Event
    event Stake(address owner, uint256 amount);

    constructor(address exampleExternalContractAddress) {
        exampleExternalContract = ExampleExternalContract(
            exampleExternalContractAddress
        );
    }

    modifier notCompleted() {
        require(!exampleExternalContract.completed(), "Funding Close");
        _;
    }

    function stake() public payable notCompleted {
        // if (deadline > block.timestamp) {
        // 	balances[msg.sender] = msg.value;
        // 	//totalAmount += msg.value;
        // 	emit Stake(msg.sender, msg.value);
        // }
        require(timeLeft() > 0, "Sorry times up");
        balances[msg.sender] += msg.value;
        emit Stake(msg.sender, msg.value);
    }

    function execute() public notCompleted {
        if (block.timestamp >= deadline) {
            if (address(this).balance > threshold) {
                exampleExternalContract.complete{
                    value: address(this).balance
                }();
            }
        }
        canWithdraw = true;
    }

    function withdraw() public {
        require(canWithdraw, "Withdraw currently not available");
        (bool success, ) = msg.sender.call{value: balances[msg.sender]}("");
        require(success, "Failed to send Ether");
    }

    function timeLeft() public view returns (uint256) {
        if (block.timestamp >= deadline) {
            return 0;
        }
        return deadline - block.timestamp;
    }

    function recieve() external payable {
        stake();
    }
}
