const { ethers } = require("hardhat")

const { network, run } = require("hardhat")
const { Contract } = require("hardhat/internal/hardhat-network/stack-traces/model")

async function main() {
  const AuctionHouse = await ethers.getContractFactory("AuctionHouse")
  console.log("Deploying AuctionHouse...")
  const contract = await upgrades.deployProxy(AuctionHouse, ["0xC1e1336e0b25038a8fF92dE84EdE6E44a76fe9BF","0x34136d58CB3ED22EB4844B481DDD5336886b3cec"], {
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