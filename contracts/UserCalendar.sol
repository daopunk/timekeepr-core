// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract UserCalendar {
  uint256 public utc;
  uint256 public rate;
  uint256 public appointmentId = 1;
  address public owner;

  struct Appointment {
    uint256 id;
    string title;
    address attendee;
    uint256 start;
    uint256 end;
    uint256 payRate;
  }

  Appointment[] public appointments;

  constructor() {
    owner = msg.sender;
  }

  function createUtc(uint256 _utc) external {
    // UTC range from -12 to +12
    require(msg.sender == owner);
    utc = _utc;
  }

  function getUtc() external view returns(uint256) {
    return utc;
  }

  function currentTime() external view returns(uint256) {
    return uint256(block.timestamp + (utc * 60 * 60));
  }

  function createRate(uint256 _rate) external {
    require(msg.sender == owner);
    rate = _rate;
  }

  function getRate() external view returns(uint256) {
    return rate;
  }

  function createAppointment(string memory _title, address _attendee, uint256 _start, uint256 _end) external {
    Appointment memory appointment;
    appointment.id = appointmentId;
    appointment.title = _title;
    appointment.attendee = _attendee;
    appointment.start = _start;
    appointment.end = _end;
    appointment.payRate = rate;

    appointments.push(appointment);
    appointmentId = appointmentId+1;
  }

  function readAppointments() external view returns (Appointment[] memory) {
    return appointments;
  }

  function deleteAppointment(uint256 _appointmentId) external {
    for (uint256 i=0; i<appointments.length; i++) {
      if (_appointmentId == appointments[i].id) {
        delete appointments[i];
      }
    }
  }
}