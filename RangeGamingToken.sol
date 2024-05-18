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
