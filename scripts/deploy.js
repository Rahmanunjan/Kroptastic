const hre = require("hardhat");

async function main() {
  const [deployer, farmer, maltster, exporter, brewery] = await hre.ethers.getSigners();

  const Factory = await hre.ethers.getContractFactory("BarleyHarvestTracker");
  const contract = await Factory.deploy(
    farmer.address,
    maltster.address,
    exporter.address,
    brewery.address
  );

  await contract.waitForDeployment();

  console.log("BarleyHarvestTracker deployed to:", contract.target);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
