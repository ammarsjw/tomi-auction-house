// SPDX-License-Identifier: GNU GPLv3

pragma solidity 0.8.19;

/**
 * @dev The `Price` is considered as the 1D index.
 * @dev The `Bidder` is considered as the 2D index.
 */
abstract contract LinkedList {

    struct Position {
        int256 votes;
        uint256 position;
    }

    struct Node {
        int256 next;
        int256 prev;

        address[] bidders;
    }

    struct AllPosition {
        mapping (int256 => Node) nodes;

        int256 head;
        int256 tail;

        uint256 totalVoteCount;
    }

    /// @dev The LinkedList.
    AllPosition internal _allPositions;
    /// @dev Reveals the number of votes and position in their corresponding node's `Positions` array relevant to each `Bidder`.
    mapping (address => Position) public getPosition;

    function __LinkedList_init() internal {
        __LinkedList_init_unchained();
    }

    function __LinkedList_init_unchained() internal {
        // HEAD's next will always be ZERO and prev will always be HIGHEST VOTES
        _allPositions.head = -1;
        // TAIL's next will always be LOWEST VOTES and prev will always be ZERO
        _allPositions.tail = 0;

        _allPositions.nodes[_allPositions.head].prev = _allPositions.tail;
        _allPositions.nodes[_allPositions.tail].next = _allPositions.head;
    }

    function insertUp(uint256 tokenId) internal {
        bool nodeCreated;
        Position storage currentPosition = getPosition[tokenId];
        int256 lastVotes = currentPosition.votes;
        Node storage lastNode = _allPositions.nodes[lastVotes];
        if (currentPosition.votes != 0) {
            uint256[] storage currentTokenIds = _allPositions.nodes[currentPosition.votes].tokenIds;

            // getting the last tokenId and its position data
            uint256 lastTokenId = currentTokenIds[currentTokenIds.length - 1];
            Position storage lastPosition = getPosition[lastTokenId];

            // replacing our given tokenId with last tokenId
            currentTokenIds[currentPosition.position] = currentTokenIds[lastPosition.position];

            // removing the duplicate last tokenId
            currentTokenIds.pop();

            if (currentTokenIds.length == 0) {
                Node storage currentNode = _allPositions.nodes[currentPosition.votes];

                // getting the given node's next and prev
                Node storage nextNode = _allPositions.nodes[currentNode.next];
                Node storage prevNode = _allPositions.nodes[currentNode.prev];

                // changing linkage for removal
                prevNode.next = currentNode.next;
                nextNode.prev = currentNode.prev;

                // setting lastVotes and lastNode
                lastVotes = currentNode.prev;
                lastNode = _allPositions.nodes[lastVotes];

                // deleting given node
                delete _allPositions.nodes[currentPosition.votes];
            }

            // saving new position of last tokenId
            lastPosition.position = currentPosition.position;
        }

        // changing votes for our given tokenId
        currentPosition.votes++;

        uint256[] storage nextTokenIds = _allPositions.nodes[currentPosition.votes].tokenIds;

        if (nextTokenIds.length == 0) {
            nodeCreated = true;
        }

        // pushing our given tokenId into the relevant/next node
        nextTokenIds.push(tokenId);

        // changing the position of our given tokenId to it's new position in the relevant/next node
        currentPosition.position = nextTokenIds.length - 1;

        if (nodeCreated) {
            Node storage currentNode = _allPositions.nodes[currentPosition.votes];
            Node storage nextNode = _allPositions.nodes[lastNode.next];

            // changing linkage for node given it was newly created
            currentNode.next = lastNode.next;
            currentNode.prev = lastVotes;

            // changing next node's linkage
            nextNode.prev = currentPosition.votes;

            // changing given tokenId's last node's linkage
            lastNode.next = currentPosition.votes;
        }

        _allPositions.totalVoteCount++;
    }

    function remove(uint256 tokenId) internal {
        Position storage currentPosition = getPosition[tokenId];

        uint256[] storage currentTokenIds = _allPositions.nodes[currentPosition.votes].tokenIds;

        // getting the last tokenId and its position data
        uint256 lastTokenId = currentTokenIds[currentTokenIds.length - 1];
        Position storage lastPosition = getPosition[lastTokenId];

        // replacing our given tokenId with last tokenId
        currentTokenIds[currentPosition.position] = currentTokenIds[lastPosition.position];

        // removing the duplicate last tokenId
        currentTokenIds.pop();

        // saving new position of last tokenId
        lastPosition.position = currentPosition.position;

        // adjusting next/prev if node is empty
        if (currentTokenIds.length == 0) {
            Node storage currentNode = _allPositions.nodes[currentPosition.votes];

            // getting the given node's next and prev
            Node storage nextNode = _allPositions.nodes[currentNode.next];
            Node storage prevNode = _allPositions.nodes[currentNode.prev];

            // changing linkage for removal
            prevNode.next = currentNode.next;
            nextNode.prev = currentNode.prev;

            // deleting given node
            delete _allPositions.nodes[currentPosition.votes];
        }

        // deleting given position
        delete getPosition[tokenId];
    }

    function getHighest() internal view returns (bool isValid, uint256 winner) {
        Node memory headNode = _allPositions.nodes[_allPositions.head];

        // node before head will contain tokenIds with highest votes
        Node memory highestNode = _allPositions.nodes[headNode.prev];

        // arbitrarily choosing the first tokenId in the node as the one with highest votes
        if (highestNode.tokenIds.length > 0) {
            isValid = true;
            winner = highestNode.tokenIds[0];
        }
    }

    function allPositions(int256 votes, uint256 position) external view returns (uint256) {
        return _allPositions.nodes[votes].tokenIds[position];
    }

    function allNodes(int256 votes) external view returns (uint256[] memory tokenIds, int256 next, int256 prev) {
        return (
            _allPositions.nodes[votes].tokenIds,
            _allPositions.nodes[votes].next,
            _allPositions.nodes[votes].prev
        );
    }
}