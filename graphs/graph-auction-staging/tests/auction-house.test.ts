import {
  assert,
  describe,
  test,
  clearStore,
  beforeAll,
  afterAll
} from "matchstick-as/assembly/index"
import { BigInt, Address } from "@graphprotocol/graph-ts"
import { AuctionBid } from "../generated/schema"
import { AuctionBid as AuctionBidEvent } from "../generated/AuctionHouse/AuctionHouse"
import { handleAuctionBid } from "../src/auction-house"
import { createAuctionBidEvent } from "./auction-house-utils"

// Tests structure (matchstick-as >=0.5.0)
// https://thegraph.com/docs/en/developer/matchstick/#tests-structure-0-5-0

describe("Describe entity assertions", () => {
  beforeAll(() => {
    let auctionIndex = BigInt.fromI32(234)
    let bidIndex = BigInt.fromI32(234)
    let bidder = Address.fromString(
      "0x0000000000000000000000000000000000000001"
    )
    let price = BigInt.fromI32(234)
    let amountTomi = BigInt.fromI32(234)
    let token = Address.fromString("0x0000000000000000000000000000000000000001")
    let newAuctionBidEvent = createAuctionBidEvent(
      auctionIndex,
      bidIndex,
      bidder,
      price,
      amountTomi,
      token
    )
    handleAuctionBid(newAuctionBidEvent)
  })

  afterAll(() => {
    clearStore()
  })

  // For more test scenarios, see:
  // https://thegraph.com/docs/en/developer/matchstick/#write-a-unit-test

  test("AuctionBid created and stored", () => {
    assert.entityCount("AuctionBid", 1)

    // 0xa16081f360e3847006db660bae1c6d1b2e17ec2a is the default address used in newMockEvent() function
    assert.fieldEquals(
      "AuctionBid",
      "0xa16081f360e3847006db660bae1c6d1b2e17ec2a-1",
      "auctionIndex",
      "234"
    )
    assert.fieldEquals(
      "AuctionBid",
      "0xa16081f360e3847006db660bae1c6d1b2e17ec2a-1",
      "bidIndex",
      "234"
    )
    assert.fieldEquals(
      "AuctionBid",
      "0xa16081f360e3847006db660bae1c6d1b2e17ec2a-1",
      "bidder",
      "0x0000000000000000000000000000000000000001"
    )
    assert.fieldEquals(
      "AuctionBid",
      "0xa16081f360e3847006db660bae1c6d1b2e17ec2a-1",
      "price",
      "234"
    )
    assert.fieldEquals(
      "AuctionBid",
      "0xa16081f360e3847006db660bae1c6d1b2e17ec2a-1",
      "amountTomi",
      "234"
    )
    assert.fieldEquals(
      "AuctionBid",
      "0xa16081f360e3847006db660bae1c6d1b2e17ec2a-1",
      "token",
      "0x0000000000000000000000000000000000000001"
    )

    // More assert options:
    // https://thegraph.com/docs/en/developer/matchstick/#asserts
  })
})
