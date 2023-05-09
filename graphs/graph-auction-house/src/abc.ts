// // import { json } from '@graphprotocol/graph-ts';
// // import fetch from 'node-fetch';
// // declare global {
// //   interface JSON  {
// //       stringify: (obj: any) => string,
// //       parse: any
// //   }
// // }

// import {
//     AuctionBid as AuctionBidEvent,
//     AuctionBidLimitUpdated as AuctionBidLimitUpdatedEvent,
//     AuctionCancelBid as AuctionCancelBidEvent,
//     AuctionClaim as AuctionClaimEvent,
//     AuctionCreated as AuctionCreatedEvent,
//     AuctionDurationUpdated as AuctionDurationUpdatedEvent,
//     AuctionFundsWalletUpdated as AuctionFundsWalletUpdatedEvent,
//     AuctionSettled as AuctionSettledEvent,
//     AuctionTeamWalletUpdated as AuctionTeamWalletUpdatedEvent,
//     Initialized as InitializedEvent,
//     OwnershipTransferred as OwnershipTransferredEvent
//   } from "../generated/AuctionHouse/AuctionHouse"
//   import {
//     AuctionBid,
//     AuctionBidLimitUpdated,
//     AuctionCancelBid,
//     AuctionClaim,
//     AuctionCreated,
//     AuctionDurationUpdated,
//     AuctionFundsWalletUpdated,
//     AuctionSettled,
//     AuctionTeamWalletUpdated,
//     Initialized,
//     OwnershipTransferred
//   } from "../generated/schema"
  
   
  
  
//   export   function handleAuctionBid(event: AuctionBidEvent): any {
//     let entity = new AuctionBid(
//       event.transaction.hash.concatI32(event.logIndex.toI32())
//     )
//     entity.auctionIndex = event.params.auctionIndex
//     entity.bidIndex = event.params.bidIndex
//     entity.bidder = event.params.bidder
//     entity.price = event.params.price
//     entity.amountTomi = event.params.amountTomi
//     entity.token = event.params.token
  
//     entity.blockNumber = event.block.number
//     entity.blockTimestamp = event.block.timestamp
//     entity.transactionHash = event.transaction.hash
  
//     //   let auth = "A2BCE232FB2178DEFN:bjfve673dhf3782rtqr922809564321z"
//     // const encodedString = Buffer.from(auth).toString('base64');
//     // let headers = {
//     //   'Content-type ':'application.json',
//     //   'Authorization':`Basic ${encodedString}`
//     // }
  
//     let data = ({
//       walletAddress: event.params.bidder,
//       amount : event.params.amountTomi,
//       transactionHash : event.transaction.hash
//     });
  
    
//     const options = {
//       method: 'POST',
//       headers: { 'Content-Type': 'application/graphql' },
//       body: JSON.stringify(data),
//     };
  
//     fetch('http://ec2-35-90-243-230.us-west-2.compute.amazonaws.com:8070/purchases', options)
  
//     .then( (response:any) => {
//       if (!response.ok) {
//         throw new Error(`Failed to send data: ${response.statusText}`);
//       }
//       console.log('Data sent successfully');
//     })
//     .catch((error:any) => {
//       console.error(`Failed to send data: ${error.message}`);
//     });
  
//       // fetch('http://ec2-35-90-243-230.us-west-2.compute.amazonaws.com:8070/purchases' , {
//       //   method : "POST",
//       //   body : JSON.stringify(data),
//       //   headers
//       // })
  
      
//   //   mapping(PostDataInput => PostDataOutput) {
//   //     post("http://ec2-35-90-243-230.us-west-2.compute.amazonaws.com:8070/purchases", { body: { data: data } }) 
      
//   //     .then(response => ({ success: response.status === 200 })) .catch(error => console.error(error)) } 
  
    
//   //   entity.save()
//   }
  
//   export function handleAuctionBidLimitUpdated(
//     event: AuctionBidLimitUpdatedEvent
//   ): void {
//     let entity = new AuctionBidLimitUpdated(
//       event.transaction.hash.concatI32(event.logIndex.toI32())
//     )
//     entity.bidLimit = event.params.bidLimit
  
//     entity.blockNumber = event.block.number
//     entity.blockTimestamp = event.block.timestamp
//     entity.transactionHash = event.transaction.hash
  
//     entity.save()
//   }
  
//   export function handleAuctionCancelBid(event: AuctionCancelBidEvent): void {
//     let entity = new AuctionCancelBid(
//       event.transaction.hash.concatI32(event.logIndex.toI32())
//     )
//     entity.auctionIndex = event.params.auctionIndex
//     entity.bidIndex = event.params.bidIndex
//     entity.bidder = event.params.bidder
  
//     entity.blockNumber = event.block.number
//     entity.blockTimestamp = event.block.timestamp
//     entity.transactionHash = event.transaction.hash
  
//     entity.save()
//   }
  
//   export function handleAuctionClaim(event: AuctionClaimEvent): void {
//     let entity = new AuctionClaim(
//       event.transaction.hash.concatI32(event.logIndex.toI32())
//     )
//     entity.auctionIndex = event.params.auctionIndex
//     entity.bidIndex = event.params.bidIndex
//     entity.bidder = event.params.bidder
  
//     entity.blockNumber = event.block.number
//     entity.blockTimestamp = event.block.timestamp
//     entity.transactionHash = event.transaction.hash
  
//     entity.save()
//   }
  
//   export function handleAuctionCreated(event: AuctionCreatedEvent): void {
//     let entity = new AuctionCreated(
//       event.transaction.hash.concatI32(event.logIndex.toI32())
//     )
//     entity.auctionIndex = event.params.auctionIndex
//     entity.startTime = event.params.startTime
//     entity.endTime = event.params.endTime
  
//     entity.blockNumber = event.block.number
//     entity.blockTimestamp = event.block.timestamp
//     entity.transactionHash = event.transaction.hash
  
//     entity.save()
//   }
  
//   export function handleAuctionDurationUpdated(
//     event: AuctionDurationUpdatedEvent
//   ): void {
//     let entity = new AuctionDurationUpdated(
//       event.transaction.hash.concatI32(event.logIndex.toI32())
//     )
//     entity.duration = event.params.duration
  
//     entity.blockNumber = event.block.number
//     entity.blockTimestamp = event.block.timestamp
//     entity.transactionHash = event.transaction.hash
  
//     entity.save()
//   }
  
//   export function handleAuctionFundsWalletUpdated(
//     event: AuctionFundsWalletUpdatedEvent
//   ): void {
//     let entity = new AuctionFundsWalletUpdated(
//       event.transaction.hash.concatI32(event.logIndex.toI32())
//     )
//     entity.funds = event.params.funds
  
//     entity.blockNumber = event.block.number
//     entity.blockTimestamp = event.block.timestamp
//     entity.transactionHash = event.transaction.hash
  
//     entity.save()
//   }
  
//   export function handleAuctionSettled(event: AuctionSettledEvent): void {
//     let entity = new AuctionSettled(
//       event.transaction.hash.concatI32(event.logIndex.toI32())
//     )
//     entity.auctionIndex = event.params.auctionIndex
  
//     entity.blockNumber = event.block.number
//     entity.blockTimestamp = event.block.timestamp
//     entity.transactionHash = event.transaction.hash
  
//     entity.save()
//   }
  
//   export function handleAuctionTeamWalletUpdated(
//     event: AuctionTeamWalletUpdatedEvent
//   ): void {
//     let entity = new AuctionTeamWalletUpdated(
//       event.transaction.hash.concatI32(event.logIndex.toI32())
//     )
//     entity.team = event.params.team
  
//     entity.blockNumber = event.block.number
//     entity.blockTimestamp = event.block.timestamp
//     entity.transactionHash = event.transaction.hash
  
//     entity.save()
//   }
  
//   export function handleInitialized(event: InitializedEvent): void {
//     let entity = new Initialized(
//       event.transaction.hash.concatI32(event.logIndex.toI32())
//     )
//     entity.version = event.params.version
  
//     entity.blockNumber = event.block.number
//     entity.blockTimestamp = event.block.timestamp
//     entity.transactionHash = event.transaction.hash
  
//     entity.save()
//   }
  
//   export function handleOwnershipTransferred(
//     event: OwnershipTransferredEvent
//   ): void {
//     let entity = new OwnershipTransferred(
//       event.transaction.hash.concatI32(event.logIndex.toI32())
//     )
//     entity.previousOwner = event.params.previousOwner
//     entity.newOwner = event.params.newOwner
  
//     entity.blockNumber = event.block.number
//     entity.blockTimestamp = event.block.timestamp
//     entity.transactionHash = event.transaction.hash
  
//     entity.save()
//   }
  