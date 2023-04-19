// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// Uncomment this line to use console.log
// import "hardhat/console.sol";

contract Token {

}

contract Lock {
    uint public unlockTime;
    address payable public owner;

    event Withdrawal(uint amount, uint when);

    constructor(uint _unlockTime) payable {
        require(
            block.timestamp < _unlockTime,
            "Unlock time should be in the future"
        );

        unlockTime = _unlockTime;
        owner = payable(msg.sender);
    }

    function withdraw() public {
        // Uncomment this line, and the import of "hardhat/console.sol", to print a log in your terminal
        // console.log("Unlock time is %o and block timestamp is %o", unlockTime, block.timestamp);

        require(block.timestamp >= unlockTime, "You can't withdraw yet");
        require(msg.sender == owner, "You aren't the owner");

        emit Withdrawal(address(this).balance, block.timestamp);

        owner.transfer(address(this).balance);
    }
}

contract Initializer {
    function init() public returns (address) {
        Lock lock = new Lock(block.timestamp + 10);
        // lock.deposit{value: 100 ether}();
        return address(lock);
    }
}

contract EchidnaContract {
    Lock lock;
    address payable owner;

    function echidna_alwaystrue() public pure returns (bool) {
        return (true);
    }

    function echidna_revert_always() public pure returns (bool) {
        revert();
    }

    // function echidna_sometimesfalse() public returns (bool) {
    //     return (lock.unlockTime() == 0);
    // }

    function echidna_init() public returns (bool) {
        Initializer initializer = new Initializer();
        lock = Lock(initializer.init());
        // owner = payable(address(this));
        // lock.transferOwnership(owner);
        return true;
    }
}
