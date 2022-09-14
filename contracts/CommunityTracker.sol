// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract CommunityTracker {
  address public owner;

  mapping(address => address) userCalendars;

  constructor() {
    owner = msg.sender;
  }

  // Link EOA account to deployed UserCalendar contract
  function addUserCalendar(address userAddress, address userCalendar) external {
    userCalendars[userAddress] = userCalendar;
  }


}