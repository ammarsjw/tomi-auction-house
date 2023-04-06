const { ethers, upgrades } = require("hardhat")

async function main() {
  const contractAddress = "0xB1D6cce36D5b773Cd64b0e550De7dc312c05Fa14"

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