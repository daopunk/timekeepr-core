const hre = require("hardhat");
require('dotenv').config();

/**
 * @dev npx hardhat run scripts/deployAll.js --network mumbai
 */

const deployerAddress = process.env.PUB_KEY;
const environment = process.env.ENVIRONMENT;

async function main() {
  const CommunityTracker = await ethers.getContractFactory("CommunityTracker");
  this.tracker = await CommunityTracker.deploy(deployerAddress);
  await this.tracker.deployed();

  const UserCalendar = await ethers.getContractFactory("UserCalendar");
  this.userCal = await UserCalendar.deploy();
  await this.userCal.deployed();

  const CalendarFactory = await ethers.getContractFactory("CalendarFactory");
  this.factory = await CalendarFactory.deploy(deployerAddress);
  await this.factory.deployed();

  this.factory.setBases(this.userCal.address, this.tracker.address);

  console.log(``);
  }

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
