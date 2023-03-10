// SPDX-License-Identifier: GNU GPLv3

pragma solidity ^0.8.0;

import "./IERC20Upgradeable.sol";

interface ITomi is IERC20Upgradeable {

    function mint(address to, uint256 amount) external returns (bool);
}