// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;
import "./UserCalendar.sol";
import "./CloneFactory.sol";

contract CalendarFactory is CloneFactory {
  mapping(address => UserCalendar) userCalendars;
  UserCalendar[] public userCalendarsArray;

  event UserCalCreated(address userCalAddress);

  function createUserCal(address communityTracker) external {
    UserCalendar userCalendar = UserCalendar(createClone(target));

    userCalendars[msg.sender] = userCalendar;
    UserCalendar.push(userCalendar);

    emit UserCalCreated(communityTracker);
  }

  function getUserCalendarClone(address user) external view returns (address userCalendar) {
    return userCalendars[user];
  }

  function getAllUserCalendarClones(address user) external view returns (UserCalendar[] memory) {
    return userCalendarsArray;
  }
}
