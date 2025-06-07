// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {ERC721} from "../lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
import {Base64} from "../lib/openzeppelin-contracts/contracts/utils/Base64.sol";
import {console} from '../lib/forge-std/src/console.sol';

contract MoodNft is ERC721 {
    uint256 private s_tokenCounter;
    string private s_sadSvgImageUri; // svg link of sad
    string private s_happySvgImageUri; // svg link of happy

    // errors
    error MoodNft__CantFlipMoodIfNotOwner();

    enum Mood {
        HAPPY,// console.log(Mood.HAPPY) -> Returns 0
        SAD   // console.log(Mood.SAD) -> Returns 1
    }
    
    

    mapping(uint256 => Mood) private s_tokenIdToMood;
    // If 0 -> Happy
    // If 1 -> Sas

    constructor(
        string memory sadSvgImageUri,
        string memory happySvgImageUri
    ) ERC721("Mood NFT", "MN") {
        s_tokenCounter = 0;
        s_sadSvgImageUri = sadSvgImageUri;
        s_happySvgImageUri = happySvgImageUri;
        s_tokenIdToMood[s_tokenCounter] = Mood.HAPPY; // Initial mood by default is happy.
    }

    function mintNft() public {
        // public so that anyone can mint NFT
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenCounter++;
    }
    // Mood Flipping
    function flipMood(uint256 tokenId) public {
        
        if (getApproved(tokenId) != msg.sender && ownerOf(tokenId) != msg.sender) {
            revert MoodNft__CantFlipMoodIfNotOwner();
        }

        if (s_tokenIdToMood[tokenId] == Mood.HAPPY) {

            s_tokenIdToMood[tokenId] = Mood.SAD;
            
        } else {
            s_tokenIdToMood[tokenId] = Mood.HAPPY;
        }
    }

    function _baseURI() internal pure override returns (string memory) {
        return "data:application/json;base64,"; // Note that it is different
    }

    function tokenURI(
        uint256 tokenId
    ) public view override returns (string memory) {
        string memory imageURI;
        if (s_tokenIdToMood[tokenId] == Mood.HAPPY) {
            imageURI = s_happySvgImageUri;
        } else {
            imageURI = s_sadSvgImageUri;
        }

        return string(
            abi.encodePacked(
                _baseURI(),
                Base64.encode(
                    bytes( // bytes casting actually unnecessary as 'abi.encodePacked()' returns a bytes
                        abi.encodePacked(
                            '{"name":"',
                            name(), // You can add whatever name here
                            '", "description":"An NFT that reflects the mood of the owner, 100% on Chain!", ',
                            '"attributes": [{"trait_type": "moodiness", "value": 100}], "image":"',
                            imageURI,
                            '"}'
                        )
                    )
                )
            )
        );

    }
}
