const { ethers, waffle } = require("hardhat");
const {
  time,
  loadFixture,
} = require("@nomicfoundation/hardhat-network-helpers");
const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");
const { expect } = require("chai");

describe("UserCalendar", function () {
  let addr;

  before(async function() {
    const UserCalendar = await ethers.getContractFactory("UserCalendar");
    this.userCal = await UserCalendar.deploy();
    await this.userCal.deployed();
    console.log('f')
  });
  console.log('f')

  it("set and check rate", async function (){
    this.userCal.createUtc(8);
    console.log('f')
    expect(await this.userCal.getUtc().to.equal("8"));
  });

});
