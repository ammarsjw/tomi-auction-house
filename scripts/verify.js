const { ethers, upgrades } = require("hardhat")

async function main() {
  const contractAddress = ""

  await new Promise(resolve => setTimeout(resolve, 10000))
  verify(contractAddress, [])
}

main()

async function verify(address, constructorArguments) {
  console.log(`verify  ${address} with arguments ${constructorArguments.join(',')}`)
  await run("verify:verify", {
    address,
    constructorArguments
  })
}