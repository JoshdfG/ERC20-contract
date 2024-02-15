import { ethers } from "hardhat";

async function main() {
  const totalSupply = 1000000;
  const name = "MyToken";
  const symbol = "MT";

  const ercToken = await ethers.deployContract("Erc20", [
    totalSupply,
    name,
    symbol,
  ]);

  await ercToken.waitForDeployment();

  console.log(`Erc20 contract deployed to: ${ercToken.target}`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
