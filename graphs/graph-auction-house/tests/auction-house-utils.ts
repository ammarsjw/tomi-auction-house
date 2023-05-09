import { newMockEvent } from "matchstick-as"
import { ethereum, BigInt, Address } from "@graphprotocol/graph-ts"
import {
  AuctionBid,
  AuctionBidLimitUpdated,
  AuctionCancelBid,
  AuctionClaim,
  AuctionCreated,
  AuctionDurationUpdated,
  AuctionFundsWalletUpdated,
  AuctionSettled,
  AuctionTeamWalletUpdated,
  Initialized,
  OwnershipTransferred
} from "../generated/AuctionHouse/AuctionHouse"

export function createAuctionBidEvent(
  auctionIndex: BigInt,
  bidIndex: BigInt,
  bidder: Address,
  price: BigInt,
  amountTomi: BigInt,
  token: Address
): AuctionBid {
  let auctionBidEvent = changetype<AuctionBid>(newMockEvent())

  auctionBidEvent.parameters = new Array()

  auctionBidEvent.parameters.push(
    new ethereum.EventParam(
      "auctionIndex",
      ethereum.Value.fromUnsignedBigInt(auctionIndex)
    )
  )
  auctionBidEvent.parameters.push(
    new ethereum.EventParam(
      "bidIndex",
      ethereum.Value.fromUnsignedBigInt(bidIndex)
    )
  )
  auctionBidEvent.parameters.push(
    new ethereum.EventParam("bidder", ethereum.Value.fromAddress(bidder))
  )
  auctionBidEvent.parameters.push(
    new ethereum.EventParam("price", ethereum.Value.fromUnsignedBigInt(price))
  )
  auctionBidEvent.parameters.push(
    new ethereum.EventParam(
      "amountTomi",
      ethereum.Value.fromUnsignedBigInt(amountTomi)
    )
  )
  auctionBidEvent.parameters.push(
    new ethereum.EventParam("token", ethereum.Value.fromAddress(token))
  )

  return auctionBidEvent
}

export function createAuctionBidLimitUpdatedEvent(
  bidLimit: BigInt
): AuctionBidLimitUpdated {
  let auctionBidLimitUpdatedEvent = changetype<AuctionBidLimitUpdated>(
    newMockEvent()
  )

  auctionBidLimitUpdatedEvent.parameters = new Array()

  auctionBidLimitUpdatedEvent.parameters.push(
    new ethereum.EventParam(
      "bidLimit",
      ethereum.Value.fromUnsignedBigInt(bidLimit)
    )
  )

  return auctionBidLimitUpdatedEvent
}

export function createAuctionCancelBidEvent(
  auctionIndex: BigInt,
  bidIndex: BigInt,
  bidder: Address
): AuctionCancelBid {
  let auctionCancelBidEvent = changetype<AuctionCancelBid>(newMockEvent())

  auctionCancelBidEvent.parameters = new Array()

  auctionCancelBidEvent.parameters.push(
    new ethereum.EventParam(
      "auctionIndex",
      ethereum.Value.fromUnsignedBigInt(auctionIndex)
    )
  )
  auctionCancelBidEvent.parameters.push(
    new ethereum.EventParam(
      "bidIndex",
      ethereum.Value.fromUnsignedBigInt(bidIndex)
    )
  )
  auctionCancelBidEvent.parameters.push(
    new ethereum.EventParam("bidder", ethereum.Value.fromAddress(bidder))
  )

  return auctionCancelBidEvent
}

export function createAuctionClaimEvent(
  auctionIndex: BigInt,
  bidIndex: BigInt,
  bidder: Address
): AuctionClaim {
  let auctionClaimEvent = changetype<AuctionClaim>(newMockEvent())

  auctionClaimEvent.parameters = new Array()

  auctionClaimEvent.parameters.push(
    new ethereum.EventParam(
      "auctionIndex",
      ethereum.Value.fromUnsignedBigInt(auctionIndex)
    )
  )
  auctionClaimEvent.parameters.push(
    new ethereum.EventParam(
      "bidIndex",
      ethereum.Value.fromUnsignedBigInt(bidIndex)
    )
  )
  auctionClaimEvent.parameters.push(
    new ethereum.EventParam("bidder", ethereum.Value.fromAddress(bidder))
  )

  return auctionClaimEvent
}

export function createAuctionCreatedEvent(
  auctionIndex: BigInt,
  startTime: BigInt,
  endTime: BigInt
): AuctionCreated {
  let auctionCreatedEvent = changetype<AuctionCreated>(newMockEvent())

  auctionCreatedEvent.parameters = new Array()

  auctionCreatedEvent.parameters.push(
    new ethereum.EventParam(
      "auctionIndex",
      ethereum.Value.fromUnsignedBigInt(auctionIndex)
    )
  )
  auctionCreatedEvent.parameters.push(
    new ethereum.EventParam(
      "startTime",
      ethereum.Value.fromUnsignedBigInt(startTime)
    )
  )
  auctionCreatedEvent.parameters.push(
    new ethereum.EventParam(
      "endTime",
      ethereum.Value.fromUnsignedBigInt(endTime)
    )
  )

  return auctionCreatedEvent
}

export function createAuctionDurationUpdatedEvent(
  duration: BigInt
): AuctionDurationUpdated {
  let auctionDurationUpdatedEvent = changetype<AuctionDurationUpdated>(
    newMockEvent()
  )

  auctionDurationUpdatedEvent.parameters = new Array()

  auctionDurationUpdatedEvent.parameters.push(
    new ethereum.EventParam(
      "duration",
      ethereum.Value.fromUnsignedBigInt(duration)
    )
  )

  return auctionDurationUpdatedEvent
}

export function createAuctionFundsWalletUpdatedEvent(
  funds: Address
): AuctionFundsWalletUpdated {
  let auctionFundsWalletUpdatedEvent = changetype<AuctionFundsWalletUpdated>(
    newMockEvent()
  )

  auctionFundsWalletUpdatedEvent.parameters = new Array()

  auctionFundsWalletUpdatedEvent.parameters.push(
    new ethereum.EventParam("funds", ethereum.Value.fromAddress(funds))
  )

  return auctionFundsWalletUpdatedEvent
}

export function createAuctionSettledEvent(
  auctionIndex: BigInt
): AuctionSettled {
  let auctionSettledEvent = changetype<AuctionSettled>(newMockEvent())

  auctionSettledEvent.parameters = new Array()

  auctionSettledEvent.parameters.push(
    new ethereum.EventParam(
      "auctionIndex",
      ethereum.Value.fromUnsignedBigInt(auctionIndex)
    )
  )

  return auctionSettledEvent
}

export function createAuctionTeamWalletUpdatedEvent(
  team: Address
): AuctionTeamWalletUpdated {
  let auctionTeamWalletUpdatedEvent = changetype<AuctionTeamWalletUpdated>(
    newMockEvent()
  )

  auctionTeamWalletUpdatedEvent.parameters = new Array()

  auctionTeamWalletUpdatedEvent.parameters.push(
    new ethereum.EventParam("team", ethereum.Value.fromAddress(team))
  )

  return auctionTeamWalletUpdatedEvent
}

export function createInitializedEvent(version: i32): Initialized {
  let initializedEvent = changetype<Initialized>(newMockEvent())

  initializedEvent.parameters = new Array()

  initializedEvent.parameters.push(
    new ethereum.EventParam(
      "version",
      ethereum.Value.fromUnsignedBigInt(BigInt.fromI32(version))
    )
  )

  return initializedEvent
}

export function createOwnershipTransferredEvent(
  previousOwner: Address,
  newOwner: Address
): OwnershipTransferred {
  let ownershipTransferredEvent = changetype<OwnershipTransferred>(
    newMockEvent()
  )

  ownershipTransferredEvent.parameters = new Array()

  ownershipTransferredEvent.parameters.push(
    new ethereum.EventParam(
      "previousOwner",
      ethereum.Value.fromAddress(previousOwner)
    )
  )
  ownershipTransferredEvent.parameters.push(
    new ethereum.EventParam("newOwner", ethereum.Value.fromAddress(newOwner))
  )

  return ownershipTransferredEvent
}
