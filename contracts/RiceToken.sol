// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/// @dev owner should be an admin. Owner can set the RiceField and RiceMarket contract
contract RiceToken is ERC20, Ownable{
    address public RiceFeild = address(0);
    address public RiceMarket = address(0);
    constructor() ERC20("Rice Token", "RICE") Ownable(){}

    /// @dev for RiceField to mint tokens
    function mint(address _receiver, uint256 _amm) external{
        require(msg.sender == RiceFeild, "Caller must be the RiceFeild");
        _mint(_receiver, _amm);
    }

    /// @dev allows the market to spend a person's token without transfering
    function spend(address _who, uint256 _amm) external{
        require(msg.sender == RiceMarket, "Caller must be RiceMarket");
        _burn(_who, _amm);
    }

    /// @dev function allows owner to set the RiceFeild address
    function setRiceFeild(address _riceFeild) external onlyOwner{
        RiceFeild = _riceFeild;
    }

    /// @dev function allows owner to set RiceMarket
    function setRiceMarket(address _riceMarket) external onlyOwner {
        RiceMarket = _riceMarket;
    }

    /// @dev hook makes token non-transferable
    function _beforeTokenTransfer(address _from, address _to, uint256 _amm) internal override{
        require(_from == address(0) || _to == address(0), "This token is non-transferable");    //Excluding burn/mint
    }
}
