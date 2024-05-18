# RangeGamingToken for Educational Purposes

RangeGamingToken is an ERC-20 token designed for educational purposes, specifically demonstrating the functionalities of minting, transferring, redeeming, and burning tokens within a controlled environment. This token is part of a project aimed at teaching blockchain development and smart contract interactions on the Ethereum blockchain.

## Description

RangeGamingToken (DGN) facilitates learning by providing a practical example of how to implement various ERC-20 token functions such as minting new tokens, transferring tokens between participants, redeeming tokens for in-game items, and burning tokens. This project helps students understand the core concepts of blockchain technology and smart contract development.

## Getting Started

### Installing

* To interact with RangeGamingToken, you will need to use the Remix IDE, an open-source web application for Ethereum development.
* Visit [Remix IDE](https://remix.ethereum.org) and load the RangeGamingToken smart contract code.
* Compile and deploy the smart contract on the Ethereum testnet (such as Rinkeby) using the Remix environment.

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
Minting new tokens: The platform should be able to create new tokens and distribute them to players as rewards. Only the owner can mint tokens.
Transferring tokens: Players should be able to transfer their tokens to others.
Redeeming tokens: Players should be able to redeem their tokens for items in the in-game store.
Checking token balance: Players should be able to check their token balance at any time.
Burning tokens: Anyone should be able to burn tokens, that they own, that are no longer needed.
*/

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract RangeGamingToken is ERC20 {
    address private owner;
    mapping(address => bool) private registeredParticipants;

    constructor() ERC20("Degen", "DGN") {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    modifier onlyRegisteredParticipant() {
        require(registeredParticipants[msg.sender], "Address not registered");
        _;
    }

    function registerParticipant(address participant) external onlyOwner {
        require(!registeredParticipants[participant], "Participant already registered");
        registeredParticipants[participant] = true;
    }

    function unregisterParticipant(address participant) external onlyOwner {
        require(registeredParticipants[participant], "Participant not registered");
        registeredParticipants[participant] = false;
    }

    function mint(address account, uint256 amount) external onlyOwner {
        require(registeredParticipants[account], "Recipient not registered");
        _mint(account, amount);
    }

    function mintToMultipleAddresses(address[] memory recipients, uint256[] memory amounts) external onlyOwner {
        require(recipients.length == amounts.length, "Array lengths mismatch");
        for (uint256 i = 0; i < recipients.length; i++) {
            require(registeredParticipants[recipients[i]], "Recipient not registered");
            _mint(recipients[i], amounts[i]);
        }
    }

    function burnFromMultipleAddresses(address[] memory senders, uint256[] memory amounts) external onlyOwner {
        require(senders.length == amounts.length, "Array lengths mismatch");
        for (uint256 i = 0; i < senders.length; i++) {
            require(registeredParticipants[senders[i]], "Sender not registered");
            _burn(senders[i], amounts[i]);
        }
    }

    function transfer(address recipient, uint256 amount) public override onlyRegisteredParticipant returns (bool) {
        require(recipient != address(0), "ERC20: transfer to the zero address");
        _transfer(msg.sender, recipient, amount);
        return true;
    }

    function redeemGameToken(uint256 amount) external onlyRegisteredParticipant {
        require(balanceOf(msg.sender) >= amount, "Insufficient balance");
        _burn(msg.sender, amount);
    }

    function checkBalance(address account) external view returns (uint256) {
        return balanceOf(account);
    }

    function burnGameToken(uint256 amount) external onlyRegisteredParticipant {
        require(balanceOf(msg.sender) >= amount, "Insufficient balance");
        _burn(msg.sender, amount);
    }
}

```
### Executing Program

#### Compile the Contract:

1. Select the appropriate compiler version (0.8.0 or higher).
2. Click on the "Solidity Compiler" tab and then click "Compile RangeGamingToken.sol".

#### Deploy the Contract:

1. Go to the "Deploy & Run Transactions" tab.
2. Select "Injected Web3" if using MetaMask or "Remix VM" for a local deployment.
3. Click "Deploy".

#### Register Participants:

1. Use the `registerParticipant` function to register a new participant.
2. Specify the participant's address.

#### Mint Tokens:

1. Ensure you are the contract owner.
2. Use the `mint` function in the deployed contract interface to mint tokens.
3. Specify the recipient address and the amount to mint.

#### Mint to Multiple Addresses:

1. Use the `mintToMultipleAddresses` function to mint tokens to multiple addresses.
2. Provide arrays of recipient addresses and corresponding amounts.

#### Burn from Multiple Addresses:

1. Use the `burnFromMultipleAddresses` function to burn tokens from multiple addresses.
2. Provide arrays of sender addresses and corresponding amounts.

#### Transfer Tokens:

1. Use the `transfer` function to transfer tokens to another registered participant.
2. Specify the recipient address and the amount to transfer.

#### Redeem Tokens:

1. Use the `redeemGameToken` function to redeem tokens for in-game items.
2. Specify the amount to redeem.

#### Burn Tokens:

1. Use the `burnGameToken` function to burn your tokens.
2. Specify the amount to burn.

#### Check Balance:

1. Use the `checkBalance` function to check the token balance of any address.
2. Specify the address you wish to check.

## Authors

NTCIAN Josh  
[Discord: @Range](https://discordapp.com/users/Range#4932)

## License

This project is licensed under the MIT License - see the LICENSE.md file for details.
