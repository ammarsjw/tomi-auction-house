// SPDX-License-Identifier: GNU GPLv3

pragma solidity 0.8.19;

import "./interfaces/ITomi.sol";

import "./libraries/MerkleProof.sol";
import "./libraries/SafeERC20Upgradeable.sol";

import "./utils/OwnableUpgradeable.sol";

contract AuctionHouse is OwnableUpgradeable {

    /* ========== STATE VARIABLES ========== */

    /// @notice The address of the main token.
    ITomi public TOMI;
    /// @notice The address of the funds collection wallet.
    address public FUNDS;
    /// @notice The address of the governance contract.
    address public DAO;
    /// @notice The address of the team wallet.
    address public TEAM;

    /// @notice The addresses of the bidding tokens.
    address[2] public biddingTokens;

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
        uint256 bidIndex;
        address bidder;
        uint256 price;
        uint256 amountTomi;
        bool status;
        bool isClaimed;
        uint8 tokenType;
    }

    struct Auction {
        uint256 auctionIndex;
        uint256 startTime;
        uint256 endTime;
        uint256 duration;
        uint256 bidLimit;
        uint256 bidCount;
    }

    mapping (uint256 => Auction) public getAuctions;
    mapping (uint256 => mapping (uint256 => Bid)) public getBids;
    mapping (uint256 => bytes32) public getWins;

    /* ========== EVENTS ========== */

    event AuctionCreated(uint256 indexed auctionIndex, uint256 startTime, uint256 endTime);
    event AuctionBid(uint256 indexed auctionIndex, uint256 bidIndex, address bidder, uint256 price, uint256 amountTomi, address token);
    event AuctionCancelBid(uint256 indexed auctionIndex, uint256 bidIndex, address bidder);
    event AuctionClaim(uint256 indexed auctionIndex, uint256 bidIndex, address bidder);
    event AuctionSettled(uint256 indexed auctionIndex);
    event AuctionDurationUpdated(uint256 duration);
    event AuctionBidLimitUpdated(uint256 bidLimit);
    event AuctionFundsWalletUpdated(address funds);
    event AuctionTeamWalletUpdated(address team);

    /* ========== INITIALIZE ========== */

    /**
     * @notice Initializes external dependencies and state variables.
     * @dev This function can only be called once.
     * @param tomi_ The address of the `Tomi` token.
     * @param funds_ The address of the `Funds` wallet.
     * @param dao_ The address of the `DAO`.
     * @param team_ The address of the `Team` wallet.
     */
    function initialize(address tomi_, address funds_, address dao_, address team_) external initializer {
        require(_msgSender() == _initializer, "Control: caller is not the initializer");
        // TODO uncomment
        // require(!_isInitialized, "Control: already initialized");
        __Ownable_init();

        TOMI = ITomi(tomi_);
        FUNDS = funds_;
        DAO = dao_;
        TEAM = team_;

        // TODO change
        biddingTokens = [
            0x1092d50E8E14479bB769b687427B72BeE70c9534,  // USDC
            0x22d2634beC4fE8C2A1292958Cff85edb78dE3E77   // USDT
        ];

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

    function getHighestBid(uint256 auctionIndex) external view returns (uint256) {
        uint256 highestBidPrice = 0;
        uint256 highestBidIndex;

        for (uint256 i = 0 ; i < getAuctions[auctionIndex].bidCount ; i++) {
            Bid memory bid = getBids[auctionIndex][i];

            if (bid.price > highestBidPrice) {
                highestBidIndex = bid.bidIndex;
            }
        }
        return getBids[auctionIndex][highestBidIndex].price;
    }

    function getUserBids(address bidder) external view returns (uint256[] memory auctionIndexes, Bid[] memory userBids) {
        uint256 userBidsLength;

        for (uint256 i = 0 ; i < auctionCount ; i++) {
            Auction memory auction = getAuctions[i];

            for (uint256 j = 0 ; j < auction.bidCount ; j++) {
                Bid memory bid = getBids[i][j];

                if (bid.bidder == bidder) {
                    userBidsLength++;
                }
            }
        }
        auctionIndexes = new uint256[](userBidsLength);
        userBids = new Bid[](userBidsLength);
        userBidsLength = 0;

        for (uint256 i = 0 ; i < auctionCount ; i++) {
            Auction memory auction = getAuctions[i];

            for (uint256 j = 0 ; j < auction.bidCount ; j++) {
                Bid memory bid = getBids[i][j];

                if (bid.bidder == bidder) {
                    auctionIndexes[userBidsLength] = auction.auctionIndex;
                    userBids[userBidsLength] = bid;
                    userBidsLength++;
                }
            }
        }
    }

    function getBidStatus(uint256 auctionIndex, uint256 bidIndex, bytes32[] memory merkleProof) external view returns (uint8) {
        uint256 currentAuctionIndex = auctionCount - 1;
        // 0 - does not exist
        // 1 - in progress
        // 2 - win
        // 3 - loss
        uint8 status;

        for (uint256 i = 0 ; i < auctionIndex ; i++) {
            Bid memory bid = getBids[auctionIndex][bidIndex];

            if (bid.status) {
                bytes32 node = keccak256(abi.encodePacked(auctionIndex, bid.bidder, bidIndex));

                if (auctionIndex == currentAuctionIndex) {
                    status = 1;
                } else if (MerkleProof.verify(merkleProof, getWins[auctionIndex], node)) {
                    status = 2;
                } else {
                    status = 3;
                }
            }
        }
        return status;
    }

    function getBidStatuses(
        uint256[] memory auctionIndexes,
        uint256[] memory bidIndexes,
        bytes32[][] memory merkleProofs
    ) external view returns (uint8[] memory) {
        require(auctionIndexes.length == bidIndexes.length, "AuctionHouse::getBidsStatus: argument arity mismatch");
        uint256 currentAuctionIndex = auctionCount - 1;
        // 0 - does not exist
        // 1 - in progress
        // 2 - win
        // 3 - loss
        uint8[] memory statuses = new uint8[](auctionIndexes.length);

        for (uint256 i = 0 ; i < auctionIndexes.length ; i++) {
            Bid memory bid = getBids[auctionIndexes[i]][bidIndexes[i]];

            if (bid.status) {
                bytes32 node = keccak256(abi.encodePacked(auctionIndexes[i], bid.bidder, bidIndexes[i]));

                if (auctionIndexes[i] == currentAuctionIndex) {
                    statuses[i] = 1;
                } else if (MerkleProof.verify(merkleProofs[i], getWins[auctionIndexes[i]], node)) {
                    statuses[i] = 2;
                } else {
                    statuses[i] = 3;
                }
            }
        }
        return statuses;
    }

    function setFundsWallet(address funds_) external onlyOwner {
        FUNDS = funds_;

        emit AuctionFundsWalletUpdated(funds_);
    }

    function setTeamWallet(address team_) external onlyOwner {
        TEAM = team_;

        emit AuctionTeamWalletUpdated(team_);
    }

    function setDuration(uint256 duration_) external onlyOwner {
        duration = duration_;

        emit AuctionDurationUpdated(duration_);
    }

    function setBidLimit(uint256 bidLimit_) external onlyOwner {
        bidLimit = bidLimit_;

        emit AuctionBidLimitUpdated(bidLimit_);
    }

    function settleAndCreateAuction(bytes32 root) external onlyOwner {
        uint256 auctionIndex = auctionCount - 1;
        Auction memory auction = getAuctions[auctionIndex];

        require(auction.startTime != 0, "AuctionHouse::settleAndCreateAuction: auction not yet started");
        require(block.timestamp >= auction.endTime, "AuctionHouse::settleAndCreateAuction: current auction not yet completed");
        _settleAuction(root);
        _createAuction();
    }

    function _settleAuction(bytes32 root) internal {
        uint256 auctionIndex = auctionCount - 1;
        getWins[auctionIndex] = root;
        // minting to the DAO.
        TOMI.mint(DAO, 100000 * 1e18);
        // minting to the Team Wallet.
        TOMI.mint(TEAM, 80000 * 1e18);

        emit AuctionSettled(auctionCount);
    }

    function _createAuction() internal {
        Auction memory auction;
        auction.auctionIndex = auctionCount;
        auction.startTime = block.timestamp;
        auction.endTime = block.timestamp + duration;
        auction.duration = duration;
        auction.bidLimit = bidLimit;
        // auction.bidCount = 0;

        getAuctions[auctionCount] = auction;
        auctionCount++;

        emit AuctionCreated(auction.auctionIndex, auction.startTime, auction.endTime);
    }

    function createBid(uint256 price, uint256 amountTomi, uint8 tokenType) external {
        require(tokenType < biddingTokens.length, "AuctionHouse::createBid: invalid token type");
        uint256 auctionIndex = auctionCount - 1;
        Auction storage auction = getAuctions[auctionIndex];
        IERC20Upgradeable token = IERC20Upgradeable(biddingTokens[tokenType]);
        uint256 amount = (price * amountTomi) / 10 ** (18 + (18 - token.decimals()));

        require(block.timestamp < auction.endTime, "AuctionHouse::createBid: current auction completed");
        require(price > 0, "AuctionHouse::createBid: invalid price");
        require(0 < amountTomi && amountTomi < auction.bidLimit, "AuctionHouse::createBid: invalid amount tomi");
        require(amount > 0, "AuctionHouse::createBid: invalid amount");
        require(
            token.allowance(_msgSender(), address(this)) >= amount &&
            token.balanceOf(_msgSender()) >= amount,
            "AuctionHouse::createBid: insufficient allowance or balance"
        );
        Bid memory bid;
        bid.bidIndex = auction.bidCount;
        bid.bidder = _msgSender();
        bid.price = price;
        bid.amountTomi = amountTomi;
        bid.status = true;
        // bid.isClaimed = false;
        bid.tokenType = tokenType;

        getBids[auctionIndex][bid.bidIndex] = bid;
        auction.bidCount++;

        emit AuctionBid(auctionIndex, bid.bidIndex, bid.bidder, bid.price, bid.amountTomi, address(token));
    }

    function cancelBid(uint256 bidIndex) external {
        uint256 auctionIndex = auctionCount - 1;
        Bid memory bid = getBids[auctionIndex][bidIndex];

        require(bid.status, "AuctionHouse::cancelBid: invalid bidIndex");
        require(_msgSender() == bid.bidder, "AuctionHouse::cancelBid: caller is not the bidder");
        delete getBids[auctionIndex][bidIndex];

        emit AuctionCancelBid(auctionIndex, bid.bidIndex, bid.bidder);
    }

    function claim(uint256 auctionIndex, uint256 bidIndex, bytes32[] calldata merkleProof) external {
        bytes32 node = keccak256(abi.encodePacked(auctionIndex, _msgSender(), bidIndex));
        Bid storage bid = getBids[auctionIndex][bidIndex];

        require(MerkleProof.verify(merkleProof, getWins[auctionIndex], node), "AuctionHouse::claim: invalid proof");
        require(!bid.isClaimed, "AuctionHouse::claim: already claimed");
        bid.isClaimed = true;
        IERC20Upgradeable token = IERC20Upgradeable(biddingTokens[bid.tokenType]);
        uint256 amount = (bid.price * bid.amountTomi) / 10 ** (18 + (18 - token.decimals()));

        SafeERC20Upgradeable.safeTransferFrom(token, _msgSender(), FUNDS, amount);
        TOMI.mint(_msgSender(), bid.amountTomi);

        emit AuctionClaim(auctionIndex, bid.bidIndex, bid.bidder);
    }

    // TODO comments
    // TODO clean
}