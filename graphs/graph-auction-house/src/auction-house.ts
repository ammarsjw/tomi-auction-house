import {
  AuctionBid as AuctionBidEvent,
  AuctionBidLimitUpdated as AuctionBidLimitUpdatedEvent,
  AuctionCancelBid as AuctionCancelBidEvent,
  AuctionClaim as AuctionClaimEvent,
  AuctionCreated as AuctionCreatedEvent,
  AuctionDurationUpdated as AuctionDurationUpdatedEvent,
  AuctionFundsWalletUpdated as AuctionFundsWalletUpdatedEvent,
  AuctionSettled as AuctionSettledEvent,
  Initialized as InitializedEvent
} from "../generated/AuctionHouse/AuctionHouse"

import {
  AuctionBid,
  AuctionBidLimitUpdated,
  AuctionCancelBid,
  AuctionClaim,
  AuctionCreated,
  AuctionDurationUpdated,
  AuctionFundsWalletUpdated,
  AuctionSettled,
  Initialized
} from "../generated/schema"

import {
  BIGINT_ONE,
  BIGINT_ZERO
} from "./utils/constants"

export function handleAuctionBid(event: AuctionBidEvent): void {
  let entity = new AuctionBid(
    event.params.auctionIndex.toString()
    .concat("-")
    .concat(event.params.bidder.toHexString())
    .concat("-")
    .concat(event.params.bidIndex.toString())
  )
  entity.auctionIndex = event.params.auctionIndex
  entity.bidIndex = event.params.bidIndex
  entity.bidder = event.params.bidder
  entity.price = event.params.price
  entity.amountTomi = event.params.amountTomi
  entity.isClaimed = false
  entity.token = event.params.token
  entity.blockTimestamp = event.block.timestamp
  entity.save()

  let auctionCreatedEntity = AuctionCreated.load(
    event.params.auctionIndex.toString()
  )
  if (auctionCreatedEntity) {
    let temp = auctionCreatedEntity.bidCount
    auctionCreatedEntity.bidCount = temp.plus(BIGINT_ONE)
    auctionCreatedEntity.save()
  }
}

export function handleAuctionBidLimitUpdated(event: AuctionBidLimitUpdatedEvent): void {
  let entity = new AuctionBidLimitUpdated(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  )
  entity.newBidLimit = event.params.newBidLimit
  entity.oldBidLimit = event.params.oldBidLimit
  entity.blockTimestamp = event.block.timestamp
  entity.save()
}

export function handleAuctionCancelBid(event: AuctionCancelBidEvent): void {
  let entity = new AuctionCancelBid(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  )
  entity.auctionIndex = event.params.auctionIndex
  entity.bidIndex = event.params.bidIndex
  entity.bidder = event.params.bidder
  entity.blockTimestamp = event.block.timestamp
  entity.save()

  let auctionCreatedEntity = AuctionCreated.load(
    event.params.auctionIndex.toString()
  )
  if (auctionCreatedEntity) {
    let temp = auctionCreatedEntity.bidCount
    auctionCreatedEntity.bidCount = temp.minus(BIGINT_ONE)
    auctionCreatedEntity.save()
  }
}

export function handleAuctionClaim(event: AuctionClaimEvent): void {
  let entity = new AuctionClaim(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  )
  entity.auctionIndex = event.params.auctionIndex
  entity.bidIndex = event.params.bidIndex
  entity.bidder = event.params.bidder
  entity.blockTimestamp = event.block.timestamp
  entity.save()

  let auctionBidEntity = AuctionBid.load(
    event.params.auctionIndex.toString()
    .concat("-")
    .concat(event.params.bidder.toHexString())
    .concat("-")
    .concat(event.params.bidIndex.toString())
  )
  if (auctionBidEntity) {
    auctionBidEntity.isClaimed = true
    auctionBidEntity.save()
  }
}

export function handleAuctionCreated(event: AuctionCreatedEvent): void {
  let entity = new AuctionCreated(
    event.params.auctionIndex.toString()
  )
  entity.auctionIndex = event.params.auctionIndex
  entity.startTime = event.params.startTime
  entity.endTime = event.params.endTime
  entity.tokenLimit = event.params.tokenLimit
  entity.minBidPrice = event.params.minBidPrice
  entity.bidLimit = event.params.bidLimit
  entity.bidCount = BIGINT_ZERO
  entity.blockTimestamp = event.block.timestamp
  entity.save()
}

export function handleAuctionDurationUpdated(event: AuctionDurationUpdatedEvent): void {
  let entity = new AuctionDurationUpdated(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  )
  entity.newDuration = event.params.newDuration
  entity.oldDuration = event.params.oldDuration
  entity.blockTimestamp = event.block.timestamp
  entity.save()
}

export function handleAuctionFundsWalletUpdated(event: AuctionFundsWalletUpdatedEvent): void {
  let entity = new AuctionFundsWalletUpdated(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  )
  entity.newFunds = event.params.newFunds
  entity.oldFunds = event.params.oldFunds
  entity.blockTimestamp = event.block.timestamp
  entity.save()
}

export function handleAuctionSettled(event: AuctionSettledEvent): void {
  let entity = new AuctionSettled(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  )
  entity.auctionIndex = event.params.auctionIndex
  entity.blockTimestamp = event.block.timestamp
  entity.save()
}

export function handleInitialized(event: InitializedEvent): void {
  let entity = new Initialized(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  )
  entity.version = event.params.version
  entity.blockTimestamp = event.block.timestamp
  entity.save()
}