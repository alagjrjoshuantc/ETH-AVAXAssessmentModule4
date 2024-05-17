// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// Project: Degen Token (ERC-20): Unlocking the Future of Gaming

/* The smart contract should have the following functionality:
Minting new tokens: The platform should be able to create new tokens and distribute them to players as rewards. Only the owner can mint tokens.
Transferring tokens: Players should be able to transfer their tokens to others.
Redeeming tokens: Players should be able to redeem their tokens for items in the in-game store.
Checking token balance: Players should be able to check their token balance at any time.
Burning tokens: Anyone should be able to burn tokens, that they own, that are no longer needed. */

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DegenToken is ERC20, Ownable {
    mapping(uint256 => uint256) public ShopPrices;
    mapping(address => uint256) public loyaltyPoints;
    
    enum LoyaltyTier { Bronze, Silver, Gold }

    constructor() ERC20("Degen", "DGN") Ownable(msg.sender) {
        ShopPrices[1] = 150;  // Price for Degen NFT
        ShopPrices[2] = 75;   // Price for Degen T-shirt & Hoodie
        ShopPrices[3] = 40;   // Price for Random IN-GAME Item
        ShopPrices[4] = 20;   // Price for Degen Sticker
    }

    function mintDGN(address _to, uint256 _amount) public onlyOwner {
        _mint(_to, _amount);
    }

    function transferDGN(address _to, uint256 _amount) public {
        require(balanceOf(msg.sender) >= _amount, "Transfer Failed: Insufficient balance.");
        transfer(_to, _amount);
    }

    function showShopItems() external pure returns (string memory) {
        return "The items on sale: {1} Degen NFT (150) {2} Degen T-shirt & Hoodie (75) {3} Random IN-GAME Item (40) {4} Degen Sticker (20)";
    }

    function redeemDGN(uint256 _item) public {
        require(ShopPrices[_item] > 0, "Item is not available.");
        require(_item <= 4, "Item is not available.");
        require(balanceOf(msg.sender) >= ShopPrices[_item], "Redeem Failed: Insufficient balance.");
        
        // Retrieve the item price and the user's loyalty tier
        uint256 price = ShopPrices[_item];
        (string memory tier, ) = getLoyaltyTier(msg.sender);  // Extracting only the tier, ignoring points
        
        // Apply discount based on the loyalty tier
        if (keccak256(bytes(tier)) == keccak256(bytes("Silver"))) {
            price = price * 9 / 10; // 10% discount for Silver
        } else if (keccak256(bytes(tier)) == keccak256(bytes("Gold"))) {
            price = price * 8 / 10; // 20% discount for Gold
        }
        
        // Perform the transfer and update loyalty points
        transfer(owner(), price);
        loyaltyPoints[msg.sender] += price; // Add points equal to the spent amount
    }

    function burnDGN(uint256 _amount) public {
        require(balanceOf(msg.sender) >= _amount, "Burn Failed: Insufficient balance.");
        _burn(msg.sender, _amount);
        loyaltyPoints[msg.sender] += _amount / 10; // Gain 1 point per 10 tokens burned
    }

    function getBalance() external view returns (uint256) {
        return balanceOf(msg.sender);
    }

    function decimals() override public pure returns (uint8) {
        return 0;
    }

    function getItemPrice(uint256 _item) public view returns (uint256) {
        require(_item > 0 && _item <= 4, "Item does not exist.");
        return ShopPrices[_item];
    }

    function getLoyaltyTier(address _user) public view returns (string memory tier, uint256 points) {
        points = loyaltyPoints[_user];
        if (points >= 1000) tier = "Gold";
        else if (points >= 500) tier = "Silver";
        else tier = "Bronze";
    }

    function checkDiscounts(address _user) public view returns (string memory) {
        (string memory tier, ) = getLoyaltyTier(_user);  // Note: ignoring the points return value
        if (keccak256(bytes(tier)) == keccak256(bytes("Gold"))) {
            return "20% discount on all items";
        } else if (keccak256(bytes(tier)) == keccak256(bytes("Silver"))) {
            return "10% discount on all items";
        } else {
            return "No discount";
        }
    }
}
