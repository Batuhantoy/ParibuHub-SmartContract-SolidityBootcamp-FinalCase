
const hre = require("hardhat");

async function main() {

  // fetching bytecode and ABI
  const rentalContract = await hre.ethers.getContractFactory("RentalContract");
  
  // creating an instance of smart contract
  const rental= await rentalContract.deploy();

  await rental.waitForDeployment();
  console.log("deployed to", `${rental.target}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
