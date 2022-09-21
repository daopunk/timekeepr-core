// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;
import "./UserCalendar.sol";

contract CalendarFactory {
  UserCalendar[] private _userCalendar;

  event UserCalCreated(address userCalAddress);

  function createUserCal(address communityTracker) external {
    UserCalendar userCalendar = new UserCalendar(communityTracker);
    _userCalendar.push(userCalendar);

    emit UserCalCreated(communityTracker);
  }
}
