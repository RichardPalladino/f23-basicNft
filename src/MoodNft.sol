// SPDX-License-Identifier: MIT

pragma solidity 0.8.18;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract MoodNft is ERC721 {
    // errors
    error MoodNft__CantFlipMood(uint256 _tokenId);

    // data structures
    enum Mood {SAD, HAPPY}

    mapping(uint256 => Mood) private s_idToMood;

    // state variables

    uint256 private s_tokenCounter;
    string private s_sadSvgUri;
    string private s_happySvgUri;

    // functions
    constructor(string memory sadSvgUri, string memory happySvgUri) ERC721("Mood NFT", "MN") {
        s_tokenCounter = 0;
        s_sadSvgUri = sadSvgUri;
        s_happySvgUri = happySvgUri;
    }


    function mintNft() public {
        _safeMint(msg.sender, s_tokenCounter);
        s_idToMood[s_tokenCounter] = Mood.HAPPY; // default to happy
        s_tokenCounter++;
    }

    function flipMood(uint256 _tokenId) public {
        if(!_isApprovedOrOwner(msg.sender, _tokenId)) {
            revert MoodNft__CantFlipMood(_tokenId);
        }
        if (s_idToMood[_tokenId] == Mood.HAPPY) {
            s_idToMood[_tokenId] = Mood.SAD;
        } else {
            s_idToMood[_tokenId] = Mood.HAPPY;
        }
    }

    function tokenURI(uint256 _tokenId) public view override returns (string memory) {
        Mood mood = s_idToMood[_tokenId];
        string memory tokenMetadata = string(
            abi.encodePacked(_baseURI(),
                Base64.encode(
                    bytes(
                        abi.encodePacked(
                            '{"name": "Mood NFT"', ', "description": "A Mood NFT", "image":', getSvg(mood), '"}')
                        )
                    )
                )
            );
        return tokenMetadata;
    }

    function getSvg(Mood _mood) public view returns (string memory) {
        if (_mood == Mood.SAD) {
            return s_sadSvgUri;
        } else {
            return s_happySvgUri;
        }
    }

    function _baseURI() internal pure override returns (string memory) {
        return "data:application/json;base64,";
    }

}