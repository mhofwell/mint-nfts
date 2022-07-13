// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.1;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

// We need to import the helper functions from the contract that we copy/pasted.
import {Base64} from "./libraries/Base64.sol";

contract MyEpicNFT is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    string baseSVG =
        "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='black' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

    string[] color = ["Golden", "Dark", "Amber", "Hazy", "Red", "Blonde"];

    string[] country = [
        "Japanese",
        "German",
        "American",
        "Belgian",
        "English",
        "Czech",
        "Italian",
        "French",
        "Latvian"
    ];

    string[] style = [
        "Marzen",
        "Lager",
        "IPA",
        "Pale Ale",
        "Ale",
        "Stout",
        "Pilsner",
        "Farmhouse Ale",
        "Saison"
    ];

    event NFTMintEvent(address sender, uint256 tokenId);

    constructor() ERC721("brewDAONFT", "BREW") {
        console.log("it works!");
    }

    // function that returns the current tokenId

    function getCurrentTokenId() public view returns (uint256) {
        uint256 currentId = _tokenIds.current();
        return currentId;
    }

    // A function our user will hit to get their NFT

    function pickRandomColor(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        uint256 rand = random(
            string(abi.encodePacked("COLOR", Strings.toString(tokenId)))
        );
        rand = rand % color.length;
        return color[rand];
    }

    function pickRandomCountry(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        uint256 rand = random(
            string(abi.encodePacked("COUNTRY", Strings.toString(tokenId)))
        );
        rand = rand % country.length;
        return country[rand];
    }

    function pickRandomStyle(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        uint256 rand = random(
            string(abi.encodePacked("STYLE", Strings.toString(tokenId)))
        );
        rand = rand % style.length;
        return style[rand];
    }

    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }

    function makeAnEpicNFT() public {
        //get the current tokenId, this starts at 0;
        uint256 newNftId = _tokenIds.current();
        console.log(newNftId);

        require(newNftId < 50, "All 10 NFTs have been minted!");

        string memory first = pickRandomColor(newNftId);
        string memory second = pickRandomCountry(newNftId);
        string memory third = pickRandomStyle(newNftId);
        string memory combinedWord = string(
            abi.encodePacked(first, second, third)
        );

        string memory finalSvg = string(
            abi.encodePacked(baseSVG, combinedWord, "</text></svg>")
        );

        // Get all the JSON metadata in place and base64 encode it.

        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',
                        // We set the title of our NFT as the generated word.
                        combinedWord,
                        '", "description": "Membership NFT for brewDAO.", "image": "data:image/svg+xml;base64,',
                        // We add data:image/svg+xml;base64 and then append our base64 encode our svg.
                        Base64.encode(bytes(finalSvg)),
                        '"}'
                    )
                )
            )
        );

        // Just like before, we prepend data:application/json;base64, to our data.

        string memory finalTokenURI = string(
            abi.encodePacked("data:application/json;base64,", json)
        );

        console.log("\n--------------------");
        console.log(finalTokenURI);
        console.log("--------------------\n");

        //actually mint the NFT to the sender using msg.sender
        _safeMint(msg.sender, newNftId);

        // Set the NFTs data
        _setTokenURI(newNftId, finalTokenURI);

        // Increment the counter for when the next NFT is minted;
        _tokenIds.increment();
        console.log(_tokenIds.current());

        console.log(
            "An NFT with ID %s has been minted to %s",
            newNftId,
            msg.sender
        );
        console.log(finalSvg);

        emit NFTMintEvent(msg.sender, newNftId);
    }
}
