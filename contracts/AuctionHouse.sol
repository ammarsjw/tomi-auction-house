// SPDX-License-Identifier: GNU GPLv3

pragma solidity 0.8.19;

import "./libraries/SafeERC20.sol";

import "./utils/LinkedList.sol";
import "./utils/OwnableUpgradeable.sol";

contract AuctionHouse is LinkedList, Ownable {

    /* ========== STATE VARIABLES ========== */

    // TODO remove
    // uint256 private constant ONE_YEAR_TIME = 7 days;
    uint256 private constant ONE_YEAR_TIME = 365 days;

    // TODO change
    /// @notice The address of the bidding token.
    address public constant USDT = 0x0c48B9e41Fa2452158daB36096A5abf1C5Abf17C;

    /// @notice The address of the main token.
    IERC20 public TOMI;
    /// @notice The address of the funds collection wallet.
    address public FUNDS;

    // TODO change
    /// @notice The duration of a single auction.
    uint256 public duration;

    /// @notice Auction start time.
    uint256 public startTime;

    /// @notice Number of auctions formed since inception.
    uint256 private auctionCount;

    /// @dev Initialization variables.
    address private constant _initializer = 0x45faf7923BAb5A5380515E055CA700519B3e4705;
    bool private _isInitialized;

    /* ========== STORAGE ========== */

    struct Bid {
        address payable bidder;
        uint256 amount;
    }

    struct Auction {
        // ID for the pioneer (ERC721A token ID)
        uint256[] pioneerIds;
        // The time that the auction started
        uint256 startTime;
        // The time that the auction is scheduled to end
        uint256 endTime;
        // The address and amounts of the current highest bidders
        Bid[] bids;
    }

    /* ========== EVENTS ========== */

    event AuctionCreated(uint256 indexed auctionCount, uint256 startTime, uint256 endTime);
    event AuctionBid(uint256 indexed auctionCount, address sender, uint256 value, bool extended);
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
    function initialize(address tomi_, address funds_) external {
        require(_msgSender() == _initializer, "Control: caller is not the initializer");
        // TODO uncomment
        // require(!_isInitialized, "Control: already initialized");

        __Ownable_init();
        __LinkedList_init();

        TOMI = IERC20(tomi_);
        FUNDS = funds_;

        // TODO change
        duration = 5 minutes;
        // duration = 1 days;

        startTime = block.timestamp;

        // _createAuction();

        _isInitialized = true;
    }

    // TODO remove this function
    function test_tomi(address tomi_) external {
        TOMI = IERC20(tomi_);
    }

    // TODO remove this function
    function test_duration(uint256 duration_) external {
        duration = duration_;
    }

    /* ========== FUNCTIONS ========== */

    function getAuction() external view returns (uint256) {
    }

    function _settleAuction() internal {
    }

    function _createAuction() internal {
    }

    function settleCurrentAndCreateNewAuction() external {
    }

    function createBid() external payable {
    }

    function setTimeBuffer(uint256 _timeBuffer) external onlyOwner {
    }

    function setReservePrice(uint256 _reservePrice) external onlyOwner {
    }

    function setMinBidIncrementPercentage(uint8 _minBidIncrementPercentage) external onlyOwner {
    }

    function _sort() internal {
    }

    function _quickSortReverse(Bid[] memory unsortedBids, int256 left, int256 right) internal {
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