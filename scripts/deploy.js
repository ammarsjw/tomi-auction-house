const { ethers } = require("hardhat")

const { network, run } = require("hardhat")
const { Contract } = require("hardhat/internal/hardhat-network/stack-traces/model")

async function main() {
  const AuctionHouse = await ethers.getContractFactory("AuctionHouse")
  console.log("Deploying AuctionHouse...")
  const contract = await upgrades.deployProxy(AuctionHouse, [
    "0xC1e1336e0b25038a8fF92dE84EdE6E44a76fe9BF", // `Tomi` token
    "0x34136d58CB3ED22EB4844B481DDD5336886b3cec", // `Vault` holding Tomi tokens
    "0x45faf7923BAb5A5380515E055CA700519B3e4705", // `Funds` collector
    "0x45faf7923BAb5A5380515E055CA700519B3e4705", // `Admin` for changing certain Auction criteria
    "0x294d0487fdf7acecf342ae70AFc5549A6E90f3e0", // dedicated `Caller` for settling and creating Auctions
  ], {
    initializer: "initialize",
    kind: "transparent",
  })
  await contract.deployed()
  console.log("AuctionHouse deployed to:", contract.address)

  await new Promise(resolve => setTimeout(resolve, 40000))
  verify(contract.address, [])
}

main()

async function verify(address, constructorArguments) {
  console.log(`verify  ${address} with arguments ${constructorArguments.join(',')}`)
  await run("verify:verify", {
    address,
    constructorArguments
  })
}