const { ethers, upgrades } = require("hardhat");

async function main() {
  const DaoPublic = await ethers.getContractFactory(
    "DaoPublic"
  );
  console.log("Upgrading DaoPublic...");
  await upgrades.upgradeProxy(
    "0x03de193dCba0888f10E0C60c3B2CCca11B372dcE", // old address
    DaoPublic
  );
  console.log("Upgraded Successfully");
}

main();