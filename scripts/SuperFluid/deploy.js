const hre = require("hardhat");
const { Framework } = require("@superfluid-finance/sdk-core");
require("dotenv").config();

// npx hardhat run scripts/deploy.js --network goerli
async function main() {

  const provider = new hre.ethers.providers.JsonRpcProvider(process.env.GOERLI_URL);

  const sf = await Framework.create({
    chainId: (await provider.getNetwork()).chainId,
    provider,
    customSubgraphQueriesEndpoint: "",
    dataMode: "WEB3_ONLY"
  });

  const signers = await hre.ethers.getSigners();
  // We get the contract to deploy
  const MoneyRouter = await hre.ethers.getContractFactory("MoneyRouter");
  //deploy the money router account using the proper host address and the address of the first signer
  const moneyRouter = await MoneyRouter.deploy(sf.settings.config.hostAddress, signers[0].address);

  await moneyRouter.deployed();

  console.log("MoneyRouter deployed to:", moneyRouter.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
