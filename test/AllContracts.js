const { ethers } = require("hardhat");
const { expect } = require("chai");

describe("CalendarFactory Test", function () {
  let deployer, users, clones;
  let userCals = [];

  before(async function() {
    [deployer, u1, u2, u3, u4] = await ethers.getSigners();
    signers = [u1, u2, u3, u4];
    users = [u1.address, u2.address, u3.address, u4.address];
    userNames = ["Samantha", "Jonny", "Alex", "Karen"];

    const CommunityTracker = await ethers.getContractFactory("CommunityTracker");
    this.tracker = await CommunityTracker.deploy(deployer.address);
    await this.tracker.deployed();

    const UserCalendar = await ethers.getContractFactory("UserCalendar");
    this.userCal = await UserCalendar.deploy();
    await this.userCal.deployed();

    const CalendarFactory = await ethers.getContractFactory("CalendarFactory");
    this.factory = await CalendarFactory.deploy(deployer.address);
    await this.factory.deployed();

    this.factory.setBases(this.userCal.address, this.tracker.address);

    // initialize userCalendars
    for (let i=0; i<users.length; i++) {
      await this.factory.connect(signers[i]).createUserCal(userNames[i]);
    }
    clones = await this.factory.getAllUserCalendarClones();

    this.testContract = await ethers.getContractAt("UserCalendar", clones[0]);

    // for (let i=0; i<clones.length; i++) {
    //   userCals.push(await ethers.getContractAt("UserCalendar", clones[i]));
    // }
  });

  // it("check initialization setup", async function(){
  //   expect(clones.length).to.equal(4);
  // });

  it("test", async function(){
     await this.testContract.createRate(8);
     console.log(await this.testContract.getRate());
  });

  // it("set availabilities", async function(){
  //   let start = 0500;
  //   let end = 2100;
  //   for (let i=0; i<userCals.length; i++) {
  //     for (let j=0; j<7; j++) {
  //       await userCals[i].connect(signers[i]).setAvailability(j, start+(i*50), end+(i*25));
  //     }
  //     console.log(`userCal${i}: ${await userCals[i].readAvailability()}`);
  //   }
  // });
});