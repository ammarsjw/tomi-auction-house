// SPDX-License-Identifier: GNU GPLv3

pragma solidity 0.8.19;

import "./interfaces/ITomi.sol";

import "./libraries/SafeERC20Upgradeable.sol";

import "./utils/OwnableUpgradeable.sol";

contract AuctionHouse is OwnableUpgradeable {

    /* ========== STATE VARIABLES ========== */

    // TODO change
    /// @notice The address of the bidding token.
    IERC20Upgradeable public constant USDT = IERC20Upgradeable(0x0c48B9e41Fa2452158daB36096A5abf1C5Abf17C);

    /// @notice The address of the main token.
    ITomi public TOMI;
    /// @notice The address of the funds collection wallet.
    address public FUNDS;

    /// @notice The duration of a single auction.
    uint256 public duration;
    /// @notice The amount at which bids get capped.
    uint256 public bidLimit;

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

    struct Auction {
        uint256 auctionCount;
        bool status;
        uint256 startTime;
        uint256 endTime;
        uint256 duration;
        uint256 bidLimit;
        uint256 bidCount;
    }

    mapping (uint256 => Auction) public getAuctions;
    mapping (uint256 => Bid[]) public getBids;
    mapping (uint256 => bytes32) public getWins;

    /* ========== EVENTS ========== */

    event AuctionCreated(uint256 indexed auctionCount, uint256 startTime, uint256 endTime);
    event AuctionBid(uint256 indexed auctionCount, address indexed bidder, uint256 amountTomi, uint256 price);
    // event AuctionExtended(uint256 indexed auctionCount, uint256 endTime);
    event AuctionSettled(uint256 indexed auctionCount);
    // event AuctionTimeBufferUpdated(uint256 timeBuffer);
    event AuctionDurationUpdated(uint256 duration);
    event AuctionBidLimitUpdated(uint256 bidLimit);

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

        TOMI = ITomi(tomi_);
        FUNDS = funds_;

        // TODO change
        duration = 5 minutes; // 1 days
        bidLimit = 100000 * 1e18;

        _createAuction();

        _isInitialized = true;
    }

    // TODO remove this function
    function test_tomi(address tomi_) external {
        TOMI = ITomi(tomi_);
    }

    // TODO remove this function
    function test_duration(uint256 duration_) external {
        duration = duration_;
    }

    /* ========== FUNCTIONS ========== */

    // TODO?
    // function getUserWins(address bidder) external view returns (Bid[] memory) {
    // }

    function setDuration(uint256 duration_) external onlyOwner {
        duration = duration_;

        emit AuctionDurationUpdated(duration);
    }

    function setBidLimit(uint256 bidLimit_) external onlyOwner {
        bidLimit = bidLimit_;

        emit AuctionBidLimitUpdated(bidLimit);
    }

    function settleAndCreateAuction(bytes32 root) external {
        Auction memory auction = getAuctions[auctionCount - 1];

        require(auction.startTime != 0, "AuctionHouse::settleAndCreateAuction: auction not yet started");
        require(block.timestamp >= auction.endTime, "AuctionHouse::settleAndCreateAuction: current auction not yet completed");
        _settleAuction(root);
        _createAuction();
    }

    function _settleAuction(bytes32 root) internal {
        getWins[auctionCount - 1] = root;

        emit AuctionSettled(auctionCount);
    }

    function _createAuction() internal {
        Auction storage auction = getAuctions[auctionCount];
        auction.auctionCount = auctionCount;
        auction.startTime = block.timestamp;
        auction.endTime = block.timestamp + duration;
        auction.duration = duration;
        auction.bidLimit = bidLimit;
        // auction.bidCount = 0;
        auctionCount++;

        emit AuctionCreated(auctionCount, auction.startTime, auction.endTime);
    }

    function createBid(uint256 price, uint256 amountTomi) external payable {
        Auction storage auction = getAuctions[auctionCount - 1];

        require(block.timestamp < auction.endTime, "AuctionHouse::createBid: current auction completed");
        require(price > 0 && amountTomi > 0, "AuctionHouse::createBid: invalid arguments");
        SafeERC20Upgradeable.safeIncreaseAllowance(USDT, address(this), price * amountTomi);
        Bid memory bid;
        bid.bidder = _msgSender();
        bid.amountTomi = amountTomi;
        bid.price = price;
        Bid[] storage bids = getBids[auctionCount - 1];
        bids.push(bid);
        auction.bidCount = bids.length;

        emit AuctionBid(auctionCount, _msgSender(), bid.amountTomi, bid.price);
    }

    // TODO claim
    // TODO cancel bid
    // TODO bid time buffer?
    // TODO events change?
    // TODO comments
}

    // Bid[] memory bids = getBids[auctionCount - 1];
        // uint256 totalBidAmount;
        // uint256 index = bids.length - 1;

        // while (index >= 0) {
        //     Bid memory bid = bids[index];
        //     uint256 bidAmount = (bid.price * bid.amountTomi) / 1e18;

        //     if (totalBidAmount + bidAmount > bidLimit) {

        //         if (index > 0) {
        //             index--;
        //             continue;
        //         } else {
        //             break;
        //         }
        //     }

        //     if (USDT.allowance(bid.bidder, address(this)) >= bidAmount && USDT.balanceOf(bid.bidder) >= bidAmount) {
        //         // if the user has lower allowance or balance than the bid, he will not be considered
        //         SafeERC20Upgradeable.safeTransferFrom(USDT, bid.bidder, FUNDS, bidAmount);
        //         TOMI.mint(bid.bidder, bid.amountTomi);
        //         totalBidAmount += bidAmount;
        //         // if not minting here add the variable named `bid` into the winners mapping
        //         // mapping[auctionCount][_msgSender()].push(bid);
        //         // OR
        //         // emit an event with his credentials
        //     }

        //     if (index > 0) index--;
        // }