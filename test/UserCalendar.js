const { ethers } = require("hardhat");
const { expect } = require("chai");
const { time } = require("@nomicfoundation/hardhat-network-helpers");

describe("UserCalendar", function () {
  const ONE_DAY = 24 * 60 * 60;
  const ONE_HOUR = 60 * 60
  let deployer, users, now;

  before(async function() {
    [deployer, u1, u2, u3, u4] = await ethers.getSigners();
    users = [u1.address, u2.address, u3.address, u4.address];
    now = await time.latest();

    const UserCalendar = await ethers.getContractFactory("UserCalendar");
    this.userCal = await UserCalendar.deploy();
    await this.userCal.deployed();
  });

  it("set and check UTC", async function (){
    this.userCal.createUtc(8);
    expect(await this.userCal.getUtc()).to.equal("8");
  });

  it("set and check rate", async function (){
    this.userCal.createRate(5);
    expect(await this.userCal.getRate()).to.equal("5");
  });

  it("should create 3 appointments and read list", async function (){
  // args: string memory _title, address _attendee, uint256 _start, uint256 _end, uint256 _payRate
    this.userCal.createAppointment(
      "initial meet",
      users[0],
      now + ONE_DAY + (8*ONE_HOUR),
      now + ONE_DAY + (9*ONE_HOUR)
    );
    this.userCal.createAppointment(
      "second meet",
      users[1],
      now + ONE_DAY + (12*ONE_HOUR),
      now + ONE_DAY + (14*ONE_HOUR)
    );
    this.userCal.createAppointment(
      "second meet",
      users[3],
      now + ONE_DAY + (15*ONE_HOUR),
      now + ONE_DAY + (15.5*ONE_HOUR)
    );

    const apptList = await this.userCal.readAppointments();
    // console.log(apptList);
    expect(apptList.length).to.equal(3);
  });

  it("delete 2nd appointment and read list", async function() {
    await this.userCal.deleteAppointment(2);

    const apptList = await this.userCal.readAppointments();
    // console.log(apptList);
    expect(apptList[1].id).to.equal(0);
  });
});
