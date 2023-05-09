// import { json } from '@graphprotocol/graph-ts';
// import fetch from 'node-fetch';
// declare global {
//   interface JSON  {
//       stringify: (obj: any) => string,
//       parse: any
//   }
// }
// import { BigInt, Bytes } from "@graphprotocol/graph-ts";
// import axios from "axios";

import {
  AuctionBid as AuctionBidEvent,
  AuctionBidLimitUpdated as AuctionBidLimitUpdatedEvent,
  AuctionCancelBid as AuctionCancelBidEvent,
  AuctionClaim as AuctionClaimEvent,
  AuctionCreated as AuctionCreatedEvent,
  AuctionDurationUpdated as AuctionDurationUpdatedEvent,
  AuctionFundsWalletUpdated as AuctionFundsWalletUpdatedEvent,
  AuctionSettled as AuctionSettledEvent,
  AuctionTeamWalletUpdated as AuctionTeamWalletUpdatedEvent,
  Initialized as InitializedEvent,
  OwnershipTransferred as OwnershipTransferredEvent,
} from "../generated/AuctionHouse/AuctionHouse";
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
  OwnershipTransferred,
} from "../generated/schema";

export function handleAuctionBid(event: AuctionBidEvent): void {
  let entity = new AuctionBid(
    event.params.auctionIndex.toString().concat("-").concat(event.params.bidder.toHexString()).concat("-").concat(event.params.bidIndex.toString())
  );
  entity.auctionIndex = event.params.auctionIndex;
  entity.bidIndex = event.params.bidIndex;
  entity.bidder = event.params.bidder;
  entity.price = event.params.price;
  entity.amountTomi = event.params.amountTomi;
  entity.isClaimed = false;
  entity.token = event.params.token;

  entity.blockNumber = event.block.number;
  entity.blockTimestamp = event.block.timestamp;
  entity.transactionHash = event.transaction.hash;
  entity.save();
}

export function handleAuctionBidLimitUpdated(
  event: AuctionBidLimitUpdatedEvent
): void {
  let entity = new AuctionBidLimitUpdated(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  );
  entity.bidLimit = event.params.bidLimit;

  entity.blockNumber = event.block.number;
  entity.blockTimestamp = event.block.timestamp;
  entity.transactionHash = event.transaction.hash;

  entity.save();
}

export function handleAuctionCancelBid(event: AuctionCancelBidEvent): void {
  let entity = new AuctionCancelBid(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  );
  entity.auctionIndex = event.params.auctionIndex;
  entity.bidIndex = event.params.bidIndex;
  entity.bidder = event.params.bidder;

  entity.blockNumber = event.block.number;
  entity.blockTimestamp = event.block.timestamp;
  entity.transactionHash = event.transaction.hash;

  entity.save();
}

export function handleAuctionClaim(event: AuctionClaimEvent): void {
  let entity = new AuctionClaim(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  );
  entity.auctionIndex = event.params.auctionIndex;
  entity.bidIndex = event.params.bidIndex;
  entity.bidder = event.params.bidder;

  entity.blockNumber = event.block.number;
  entity.blockTimestamp = event.block.timestamp;
  entity.transactionHash = event.transaction.hash;

  entity.save();
  let _id = event.params.auctionIndex.toString().concat("-").concat(event.params.bidder.toHexString()).concat("-").concat(event.params.bidIndex.toString())

  let auctioBID = AuctionBid.load (_id)
  if (auctioBID){
    auctioBID.isClaimed = true;
    auctioBID.save();
  }
}

export function handleAuctionCreated(event: AuctionCreatedEvent): void {
  let entity = new AuctionCreated(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  );
  entity.auctionIndex = event.params.auctionIndex;
  entity.startTime = event.params.startTime;
  entity.endTime = event.params.endTime;

  entity.blockNumber = event.block.number;
  entity.blockTimestamp = event.block.timestamp;
  entity.transactionHash = event.transaction.hash;

  entity.save();
}

export function handleAuctionDurationUpdated(
  event: AuctionDurationUpdatedEvent
): void {
  let entity = new AuctionDurationUpdated(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  );
  entity.duration = event.params.duration;

  entity.blockNumber = event.block.number;
  entity.blockTimestamp = event.block.timestamp;
  entity.transactionHash = event.transaction.hash;

  entity.save();
}

export function handleAuctionFundsWalletUpdated(
  event: AuctionFundsWalletUpdatedEvent
): void {
  let entity = new AuctionFundsWalletUpdated(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  );
  entity.funds = event.params.funds;

  entity.blockNumber = event.block.number;
  entity.blockTimestamp = event.block.timestamp;
  entity.transactionHash = event.transaction.hash;

  entity.save();
}

export function handleAuctionSettled(event: AuctionSettledEvent): void {
  let entity = new AuctionSettled(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  );
  entity.auctionIndex = event.params.auctionIndex;

  entity.blockNumber = event.block.number;
  entity.blockTimestamp = event.block.timestamp;
  entity.transactionHash = event.transaction.hash;

  entity.save();
}

export function handleAuctionTeamWalletUpdated(
  event: AuctionTeamWalletUpdatedEvent
): void {
  let entity = new AuctionTeamWalletUpdated(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  );
  entity.team = event.params.team;

  entity.blockNumber = event.block.number;
  entity.blockTimestamp = event.block.timestamp;
  entity.transactionHash = event.transaction.hash;

  entity.save();
}

export function handleInitialized(event: InitializedEvent): void {
  let entity = new Initialized(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  );
  entity.version = event.params.version;

  entity.blockNumber = event.block.number;
  entity.blockTimestamp = event.block.timestamp;
  entity.transactionHash = event.transaction.hash;

  entity.save();
}

export function handleOwnershipTransferred(
  event: OwnershipTransferredEvent
): void {
  let entity = new OwnershipTransferred(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  );
  entity.previousOwner = event.params.previousOwner;
  entity.newOwner = event.params.newOwner;

  entity.blockNumber = event.block.number;
  entity.blockTimestamp = event.block.timestamp;
  entity.transactionHash = event.transaction.hash;

  entity.save();
}
