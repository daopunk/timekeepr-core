// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

interface ICommunityTracker {
  function addUserCalendar(address, address) external;
}

contract UserCalendar {
  uint256 public utc;
  uint256 public rate;
  uint256 public appointmentId = 1; // index for appointmentsArray, MUST START AT 1
  address public owner;

  struct Appointment {
    uint256 id;
    string title;
    address attendee;
    // string date;
    uint256 date;
    uint256 day;
    uint256 startTime;
    uint256 duration;
    uint256 payRate;
    // bool isActive;
  }

  /**
   * 0 - 6 days
   * mapping
   * 0000 - 2345 => true
   * 1315 -
   */
  mapping (uint256 => mapping(uint256 => bool)) public availability;

  /**
   * @dev "20220918" => (1330 => true) = appointment on September 18th, 1:30PM 
   */
  // mapping (string => mapping(uint256 => bool)) public appointments;
  mapping (uint256 => mapping(uint256 => bool)) public appointments;

  uint256[2][7] public availabilityArray = [[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0]];
  Appointment[] public appointmentsArray;

  constructor(address communityTracker) {
    owner = msg.sender;
    ICommunityTracker(communityTracker).addUserCalendar(msg.sender, address(this));
  }

  modifier onlyOwner() {
    require(msg.sender == owner, "only owner function");
    _;
  }

  function createUtc(uint256 _utc) external onlyOwner {
    // UTC range from -12 to +12
    utc = _utc;
  }

  function getUtc() external view returns(uint256) {
    return utc;
  }

  function currentTime() external view returns(uint256) {
    return uint256(block.timestamp + (utc * 60 * 60));
  }

  function createRate(uint256 _rate) external onlyOwner {
    rate = _rate;
  }

  function getRate() external view returns(uint256) {
    return rate;
  }

  /**
   * @dev set an availability block per day
   * @param _day 0-6 day of the week
   * @param _startTime 0000 - 2345 hour and minute block by 15 minute intervals
   * @param _endTime end time same format as start time
   */
  function setAvailability(uint256 _day, uint256 _startTime, uint256 _endTime) external onlyOwner {
    require(_day >= 0 && _day <= 6, "day is invalid");
    require(_startTime >= 0, "start time is invalid");
    require(_endTime <= 2345, "start time is invalid");

    uint i = _startTime;
    for (i; i < _endTime; i += 25) {
      availability[_day][i] = true;
    }
    availabilityArray[_day] = [_startTime, _endTime];
  }
  
  function readAvailability() external view returns (uint256[2][7] memory) {
    return availabilityArray;
  }

  function deleteAvailability(uint256 _day, uint256 _startTime, uint256 _endTime) external onlyOwner {
    require(_day >= 0 && _day <= 6, "day is invalid");

    uint i = _startTime;
    for (i; i < _endTime; i += 25) {
      availability[_day][i] = false;
    }
  }

  // todo: should appointments need to be proposed by anyone and approved by only owner?
  // ^not necessary for MVP, but would be nice optional feature to add

  /**
   * @param _date "20220918" -> September 18th, 2022
   * @param _day 4 -> day of the week
   * @param _startTime 1715 -> 5:15pm
   */
  function createAppointment(
    string memory _title,
    // string memory _date,
    uint256 _date,
    uint256 _day,
    address _attendee,
    uint256 _startTime,
    uint256 _duration
  ) external {

    // check if time is available
    require(_day >= 0 && _day <= 6, "day is invalid");

    for (uint256 i=0; i < _duration; i++) {
      require(availability[_day][_startTime + (i*25)] == true, "this appointment date and time is not available");
      require(appointments[_date][_startTime + (i*25)] != true, "this appointment date and time is not available because of a preexisting appointment");
    }

    Appointment memory appointment;
    appointment.id = appointmentId;
    appointment.title = _title;
    appointment.date = _date;
    appointment.day = _day;
    appointment.attendee = _attendee;
    appointment.startTime = _startTime;
    appointment.duration = _duration;
    appointment.payRate = rate;

    appointments[_date][_startTime] = true;

    for (uint256 j=0; j < _duration; j++) {
      appointments[_date][j] = true;
    }

    appointmentsArray.push(appointment);
    appointmentId = appointmentId+1;
  }

  function readAppointments() external view returns (Appointment[] memory) {
    return appointmentsArray;
  }

// wip
  // function sortAppointments() external returns (Appointment[] memory) {
  //   for (uint i=1; i<appointmentsArray.length; i++) {
  //     Appointment memory key = appointmentsArray[i];
  //     uint256 j = i-1;
  //     while (j>=0 && appointmentsArray[j].date > key.date) {
  //       appointmentsArray[j+1] = appointmentsArray[j];
  //       j = j-1;
  //     }
  //     appointmentsArray[j+1] = key;
  //   }
  //   return appointmentsArray;
  // }

  function deleteAppointment(uint256 _appointmentId) external onlyOwner {
    uint256 positionId = _appointmentId - 1;
    // string memory date = appointmentsArray[positionId].date;
    uint256 date = appointmentsArray[positionId].date;
    uint256 start = appointmentsArray[positionId].startTime;
    uint256 duration = appointmentsArray[positionId].duration;

    for (uint256 i=0; i < duration; i++) {
      appointments[date][start + (i*25)] = false;
    }
    // does not remove appt from array, only sets all data to 0
    delete appointmentsArray[positionId];
  }
}