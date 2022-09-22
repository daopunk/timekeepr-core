const hre = require("hardhat");
const { Framework } = require("@superfluid-finance/sdk-core");
const { ethers } = require("hardhat");
require("dotenv").config();
const MoneyRouterABI = require("../artifacts/contracts/MoneyRouter.sol/MoneyRouter.json").abi;

// npx hardhat run scripts/tokenApproval.js --network goerli
async function main() {
  //NOTE - make sure you add the address of the previously deployed money router contract on your network
  const moneyRouterAddress = "";

  const provider = new hre.ethers.providers.JsonRpcProvider(process.env.GOERLI_URL);

  const sf = await Framework.create({
    chainId: (await provider.getNetwork()).chainId,
    provider,
    customSubgraphQueriesEndpoint: "",
    dataMode: "WEB3_ONLY"
  });

  const signers = await hre.ethers.getSigners();

  const moneyRouter = new ethers.Contract(moneyRouterAddress, MoneyRouterABI, provider);

  const daix = await sf.loadSuperToken("fDAIx");

  //approve contract to spend 1000 daix
  const moneyRouterApproval = daix.approve({
    receiver: moneyRouter.address,
    superToken: daix.address,
    amount: ethers.utilis.parseEther("1000")
  });

  await moneyRouterApproval.exec(signers[0]).then((tx) => {
    console.log(`contract appoved: ${tx.hash}`)
  });

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
