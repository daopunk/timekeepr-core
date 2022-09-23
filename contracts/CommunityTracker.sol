// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

interface IUserCalendar {
  function createAppointment(
    string memory _title,
    string memory _date,
    uint256 _day,
    address _attendee,
    uint256 _startTime,
    uint256 _endTime) external;
}

contract CommunityTracker {
  address public owner;

  // map EOA address to UserCalendar address
  mapping(address => address) userCalendars;

  constructor(address _owner) {
    owner = _owner;
  }

  // called during UserCalendar deployment initialization
  function addUserCalendar(address userAddress, address userCalendar) external {
    userCalendars[userAddress] = userCalendar;
  }

  // loops over array of EOAs to group schedule a meeting on each UserCalendar
  function createGroupAppointment(
    address[] memory userEOAs,
    string memory _title,
    string memory _date,
    uint256 _day,
    address _attendee,
    uint256 _startTime,
    uint256 _endTime ) external {

    for (uint256 i; i < userEOAs.length; i++) {
      IUserCalendar(userEOAs[i]).createAppointment(_title, _date, _day, _attendee, _startTime, _endTime);
    }
  }
}