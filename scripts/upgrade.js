const { ethers, upgrades } = require("hardhat")

async function main() {
  const newImplementation = await ethers.getContractFactory("contracts/legacy/LegacyAuctionHouse.sol:AuctionHouse")
  console.log("Upgrading AuctionHouse")
  await upgrades.upgradeProxy(
    "0x55B2b0a3e814C870eC60648E7a02860c2326Dd2A", // old proxy address
    newImplementation
  )
  console.log("Upgraded Successfully")
}

main()