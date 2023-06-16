const hre = require("hardhat");

async function main() {
  console.log("deploying...");
  const StakeConcept = await hre.ethers.getContractFactory(
    "StakeConcept"
  );
  const marketInteractions = await StakeConcept.deploy(
    "0xeb7A892BB04A8f836bDEeBbf60897A7Af1Bf5d7F"
  );

  await marketInteractions.deployed();

  console.log(
    "StakeConcept loan contract deployed: ",
    marketInteractions.address
  );
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
