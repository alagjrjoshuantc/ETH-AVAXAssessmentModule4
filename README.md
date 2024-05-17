# DegenToken for Degen Gaming

DegenToken is an ERC-20 token designed for the Degen Gaming community. It allows gamers to earn rewards, purchase items, and enhance their engagement within the gaming ecosystem directly on the Ethereum blockchain.

## Description

DegenToken (DGN) facilitates a dynamic interaction within Degen Gaming by providing functionalities such as minting, transferring, redeeming for in-game items, and token burning. This project leverages blockchain technology to incentivize gaming achievements and loyalty, thereby enriching the player's experience and interaction within the game.

## Getting Started

### Installing

* To interact with DegenToken, you will need to use the Remix IDE, an open-source web application for Ethereum development.
* Visit [Remix IDE](https://remix.ethereum.org) and load the DegenToken smart contract code.
* Compile and deploy the smart contract on the Ethereum testnet (such as Rinkeby) using the Remix environment.

```solidity
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
```
### Executing program

1. **Compile the Contract:**

   - Select the appropriate compiler version (0.8.20 or higher).
   - Click on the "Solidity Compiler" tab and then click "Compile DegenToken.sol".

2. **Deploy the Contract:**

   - Go to the "Deploy & Run Transactions" tab.
   - Select "Injected Web3" if using MetaMask or "Remix VM" for a local deployment.
   - Click "Deploy".

3. **Mint Tokens:**

   - Ensure you are the contract owner.
   - Use the `mintDGN` function in the deployed contract interface to mint tokens.
   - Specify the recipient address and the amount to mint.

4. **Transfer Tokens:**

   - Use the `transferDGN` function to transfer tokens to another address.
   - Specify the recipient address and the amount to transfer.

5. **Redeem Tokens:**

   - Use the `redeemDGN` function to redeem tokens for in-game items.
   - Specify the item code as per the shop list.

6. **Burn Tokens:**

   - Use the `burnDGN` function to burn your tokens.
   - Specify the amount to burn.

7. **Transfer Ownership of the Contract:**

   - Use the `transferOwnership` function to transfer ownership of the contract.
   - Specify the new owner's address.

8. **Get Loyalty Tier:**

   - Use the `getLoyaltyTier` function to check the loyalty tier of any address.
   - Enter the address you wish to check.

9. **Check Discounts:**

   - Use the `checkDiscounts` function to find out available discounts for any address based on their loyalty tier.
   - Enter the address to check the applicable discounts.

## Authors

NTCIAN Josh
<br>
[Discord: @Range](https://discordapp.com/users/Range#4932)

## License

This project is licensed under the MIT License - see the LICENSE.md file for details.
