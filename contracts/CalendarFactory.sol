// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;
import "./UserCalendar.sol";
import "./CloneFactory.sol";

contract CalendarFactory is CloneFactory {
  address public owner;
  address public baseUserCalendar;

  mapping(address => address) userCalendars;
  UserCalendar[] public userCalendarsArray;

  event UserCalCreated(address userCalAddress);

  constructor(address _owner) {
    owner = _owner;
  }

  modifier onlyOwner() {
    require(msg.sender == owner, "only owner function");
    _;
  }

  function setBaseAddress(address _baseUserCalendar) external onlyOwner {
    baseUserCalendar = _baseUserCalendar;
  }

  function createUserCal(address communityTracker) external {
    UserCalendar userCalendar = UserCalendar(createClone(baseUserCalendar));
    userCalendar.init(communityTracker);

    userCalendars[msg.sender] = address(userCalendar);
    userCalendarsArray.push(userCalendar);

    emit UserCalCreated(communityTracker);
  }

  function getUserCalendarClone(address user) external view returns (address userCalendar) {
    return userCalendars[user];
  }

  function getAllUserCalendarClones() external view returns (UserCalendar[] memory) {
    return userCalendarsArray;
  }
}
