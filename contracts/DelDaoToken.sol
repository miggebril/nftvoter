// contracts/GLDToken.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.5.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v2.5.0/contracts/token/ERC20/ERC20.sol";

contract DelDaoToken is ERC20 {
    constructor() public {
        _mint(msg.sender, 777);
    }
}
