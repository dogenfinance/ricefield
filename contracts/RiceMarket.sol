// SPDX-License-Identifier: None

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

interface IRICE is IERC20{
    function spend(address, uint256) external;
}

contract RiceMarket is ERC1155, Ownable{
    IRICE public RICE;
    uint public latest;                            //The latest NFT ID

    struct Pricing{
        uint start;
        uint end;
        uint128 supply;
        uint128 sold;
    }

    mapping(uint => Pricing) prices;

    constructor(string memory _uri, address _RICE) ERC1155(_uri) Ownable(){
        RICE = IRICE(_RICE);
        latest = 0;
    }

    /// @dev events
    event Drop(uint ID, uint ammount);
    event Purchase(uint ID, uint price);

    /// @dev owner sets new URI
    function updateURI(string memory _new) external onlyOwner{
        _setURI(_new);
    }

    /// @dev release new NFTs with drop. Set ammount, start and end price
    function drop(uint128 _ammount, uint _startPrice, uint _endPrice)external onlyOwner{
        require(_endPrice > _startPrice, "Start price must be > end price");
        require(_ammount != 0, "Ammount cannot be 0");
        latest++;
        prices[latest] = Pricing(
            _startPrice,
            _endPrice,
            _ammount,
            0
        );
        _mint(address(this),latest,_ammount,"");
        emit Drop(latest, _ammount);
    }

    /// @dev buy an NFT at market rate by burning rice. No approval needed, RICE should be able to burn directly
    function buy(uint ID)external{
        require(isAvailable(ID), "No ERC1155s to sell");
        uint price = getPrice(ID);
        RICE.spend(msg.sender, price);
        prices[ID].sold++;
        safeTransferFrom(address(this), msg.sender, ID, 1, "");
        emit Purchase(ID, price);
    }

    /// @dev returns price based on linear price curve
    function getPrice(uint ID) public view returns(uint){
        Pricing memory obj = prices[ID];
        uint e = obj.end - obj.start / obj.supply;
        return obj.start + (e * obj.sold);
    }

    /// @dev find if NFT is sold out
    function isAvailable(uint ID) public view returns(bool){
        return balanceOf(address(this),ID) > 0 ? true : false;
    }

}