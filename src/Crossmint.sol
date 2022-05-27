// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.13;

import "solmate/tokens/ERC721.sol";
import "openzeppelin-contracts/contracts/access/Ownable.sol";

/// @notice Dummy contract for testing

contract Crossmint is ERC721, Ownable {
    uint256 public constant MAX_SUPPLY = 100000;
    uint256 public salePrice = 0.001 ether;
    uint256 public totalSupply;
    string public uri;

    address _crossmintAddress = 0xdAb1a1854214684acE522439684a145E62505233;

    // MODIFIERS

    modifier isCorrectPayment() {
        require(salePrice == msg.value, "Incorrect ETH value sent");
        _;
    }

    modifier isAvailable() {
        require(totalSupply + 1 <= MAX_SUPPLY, "No more left");
        _;
    }

    constructor() payable ERC721("tester", "TEST") {
        uri = "https://gateway.pinata.cloud/ipfs/QmPux5QgyPHfxjuCBf1GL6bnbYRoDdzwh9UGdnz2UXx58D";
    }

    // PUBLIC

    function mint() external payable isCorrectPayment isAvailable {
        _safeMint(msg.sender, totalSupply++);
    }

    function crossmint(address to)
        external
        payable
        isCorrectPayment
        isAvailable
    {
        require(
            msg.sender == _crossmintAddress,
            "This function is for Crossmint only."
        );
        _safeMint(to, totalSupply++);
    }

    // ADMIN

    function setBaseURI(string calldata baseURI) external onlyOwner {
        uri = baseURI;
    }

    function setSalePrice(uint256 price) external onlyOwner {
        salePrice = price;
    }

    // VIEW

    function tokenURI(uint256 tokenId)
        public
        view
        override
        returns (string memory)
    {
        return uri;
    }
}
