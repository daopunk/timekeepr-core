// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;
import "./UserCalendar.sol";
import "./CloneFactory.sol";

contract CalendarFactory is CloneFactory {
  address public owner;
  address public baseUserCalendar;
  address public communityTracker;

  // EOA address to UserCalendar address
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

  // set [base] UserCalendar address, set CommunityTracker for intitialization of UserCalendar 
  function setBases(address _baseUserCalendar, address _communityTracker) external onlyOwner {
    baseUserCalendar = _baseUserCalendar;
    communityTracker = _communityTracker;
  }

  // create instance of UserCalendar with unique userName and call initialize function (constructor)
  function createUserCal(string memory userName) external {
    UserCalendar userCalendar = UserCalendar(createClone(baseUserCalendar));
    userCalendar.init(userName, communityTracker, msg.sender);

    // add UserCalendar address to mapping and array for easy lookup
    userCalendars[msg.sender] = address(userCalendar);
    userCalendarsArray.push(userCalendar);

    emit UserCalCreated(communityTracker);
  }

  // verify a single user by thier EOA address
  function getUserCalendarClone(address userEOA) external view returns (address userCalendar) {
    return userCalendars[userEOA];
  }

  // get list of all UserCalendars
  function getAllUserCalendarClones() external view returns (UserCalendar[] memory) {
    return userCalendarsArray;
  }
}
