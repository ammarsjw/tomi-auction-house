// SPDX-License-Identifier: GNU GPLv3

pragma solidity 0.8.19;

import "./interfaces/ITomi.sol";

import "./libraries/SafeERC20Upgradeable.sol";

import "./utils/OwnableUpgradeable.sol";

contract AuctionHouse is OwnableUpgradeable {

    /* ========== STATE VARIABLES ========== */

    // TODO change
    /// @notice The address of the bidding token.
    address public constant USDT = 0x0c48B9e41Fa2452158daB36096A5abf1C5Abf17C;

    /// @notice The amount at which bids get capped.
    uint256 public constant BID_LIMIT = 100000 * 1e18;

    /// @notice The address of the main token.
    address public TOMI;
    /// @notice The address of the funds collection wallet.
    address public FUNDS;

    /// @notice The duration of a single auction.
    uint256 public duration;
    /// @notice The start time of an auction.
    uint256 public startTime;
    /// @notice The end time of an auction.
    uint256 public endTime;

    /// @notice Number of auctions formed since inception.
    uint256 public auctionCount;

    /// @dev Initialization variables.
    address private constant _initializer = 0x34136d58CB3ED22EB4844B481DDD5336886b3cec;
    bool private _isInitialized;

    /* ========== STORAGE ========== */

    struct Bid {
        address bidder;
        uint256 amountTomi;
        uint256 price;
    }

    Bid[] public bids;
    // mapping (uint256 => mapping (address => Bid[])) public wins;

    /* ========== EVENTS ========== */

    event AuctionCreated(uint256 indexed auctionCount, uint256 startTime, uint256 endTime);
    event AuctionBid(uint256 indexed auctionCount, address indexed bidder, uint256 amountTomi, uint256 price);
    event AuctionExtended(uint256 indexed auctionCount, uint256 endTime);
    event AuctionSettled(uint256 indexed auctionCount);
    event AuctionTimeBufferUpdated(uint256 timeBuffer);
    event AuctionReservePriceUpdated(uint256 reservePrice);
    event AuctionMinBidIncrementPercentageUpdated(uint256 minBidIncrementPercentage);

    /* ========== INITIALIZE ========== */

    /**
     * @notice Initialize the auction house and base contracts and populate configuration values.
     * @dev This function can only be called once.
     */
    function initialize(address tomi_, address funds_) external initializer {
        require(_msgSender() == _initializer, "Control: caller is not the initializer");
        // TODO uncomment
        // require(!_isInitialized, "Control: already initialized");
        __Ownable_init();

        TOMI = tomi_;
        FUNDS = funds_;

        // TODO change
        duration = 5 minutes; // 1 days
        startTime = block.timestamp;
        endTime = block.timestamp + duration;

        _isInitialized = true;

        emit AuctionCreated(auctionCount, startTime, endTime);
    }

    // TODO remove this function
    function test_tomi(address tomi_) external {
        TOMI = tomi_;
    }

    // TODO remove this function
    function test_duration(uint256 duration_) external {
        duration = duration_;
    }

    /* ========== FUNCTIONS ========== */

    function getUserBids(address bidder) external view returns (Bid[] memory) {
        uint256 userBidsLength;

        for (uint256 i = 0 ; i < bids.length ; i++) {
            if (bids[i].bidder == bidder) {
                userBidsLength++;
            }
        }
        Bid[] memory userBids = new Bid[](userBidsLength);
        uint256 index;

        for (uint256 i = 0 ; i < bids.length ; i++) {
            if (bids[i].bidder == bidder) {
                userBids[index];
                index++;
            }
        }
        return userBids;
    }

    function getUserWins(address bidder) external view returns (Bid[] memory) {
    }

    // TODO
    function setTimeBuffer(uint256 _timeBuffer) external onlyOwner {
    }

    function setReservePrice(uint256 _reservePrice) external onlyOwner {
    }

    function setMinBidIncrementPercentage(uint8 _minBidIncrementPercentage) external onlyOwner {
    }
    // TODO

    function settleCurrentAndCreateNewAuction() external {
        require(startTime != 0, "AuctionHouse::settleCurrentAndCreateNewAuction: auction not yet started");
        require(block.timestamp >= endTime, "AuctionHouse::settleCurrentAndCreateNewAuction: current auction not yet completed");
        _settleAuction();
        _createAuction();
    }

    function _settleAuction() internal {
        uint256 totalBidAmount;
        uint256 index = bids.length - 1;

        while (index >= 0) {
            Bid memory bid = bids[index];
            uint256 bidAmount = (bid.price * bid.amountTomi) / 1e18;

            if (totalBidAmount + bidAmount > BID_LIMIT) {

                if (index > 0) {
                    index--;
                    continue;
                } else {
                    break;
                }
            }

            // if the user has lower allowance or balance than the bid, he will not be considered
            if (
                IERC20Upgradeable(USDT).allowance(bid.bidder, address(this)) >= bidAmount &&
                IERC20Upgradeable(USDT).balanceOf(bid.bidder) >= bidAmount
            ) {
                SafeERC20Upgradeable.safeTransferFrom(IERC20Upgradeable(USDT), bid.bidder, FUNDS, bidAmount);
                ITomi(TOMI).mint(bid.bidder, bid.amountTomi);
                totalBidAmount += bidAmount;
                // if not minting here add the variable named `bid` into the winners mapping
                // mapping[auctionCount][_msgSender()].push(bid);
                // OR
                // emit an event with his credentials
            }
            index--;
        }

        emit AuctionSettled(auctionCount);
    }

    function _createAuction() internal {
        startTime = block.timestamp;
        endTime = block.timestamp + duration;
        auctionCount++;

        delete bids;

        emit AuctionCreated(auctionCount, startTime, endTime);
    }

    function createBid(uint256 price, uint256 amountTomi) external payable {
        require(block.timestamp < endTime, "AuctionHouse::createBid: current auction completed");
        require(price > 0 && amountTomi > 0, "AuctionHouse::createBid: invalid arguments");
        SafeERC20Upgradeable.safeIncreaseAllowance(IERC20Upgradeable(USDT), address(this), price * amountTomi);
        int256 pushAfter = _iterativeBinarySeatch(price);

        require(pushAfter > -2, "not good");
        Bid memory bid;
        bid.bidder = _msgSender();
        bid.amountTomi = amountTomi;
        bid.price = price;
        bids.push(bid);

        for (int256 i = int256(bids.length) - 1 ; i > pushAfter + 1 ; i--) {
            Bid memory tempBid = bids[uint256(i)];
            bids[uint256(i)] = bids[uint256(i - 1)];
            bids[uint256(i - 1)] = tempBid;
        }

        emit AuctionBid(auctionCount, _msgSender(), bid.amountTomi, bid.price);
    }

    function _iterativeBinarySeatch(uint256 price) internal view returns (int256) {
        if (bids.length == 0) {
            return 0;
        }

        if (price > bids[bids.length - 1].amountTomi) {
            return int256(bids.length - 1);
        } else if (price < bids[0].amountTomi) {
            return -1;
        }

        uint256 low = 0;
        uint256 high = bids.length - 1;
        uint256 mid;
        while (low != high) {
            mid = low + (high - low) / 2;

            if (high - low == 1 && price < bids[high].amountTomi && price > bids[low].amountTomi) {
                return int256(low);
            }

            if (price > bids[mid].amountTomi) {
                low = mid;
            } else {
                high = mid;
            }
        }

        return -2;
    }
}

// take approval
    // check that tokens< 100k
    // save that bids and address
    // insertup Linkedlist
//remove approval
    // pop from linkedlist
    // emit event
// placebid
    // take approval
    // check that tokens< 100k
    // save that bids and address
    // insertup Linkedlist
    // emit event
// cancelBid
    //remove approval
    // pop from linkedlist
    // emit event
// settleAuction
    //