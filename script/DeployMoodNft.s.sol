// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Script} from "forge-std/Script.sol";
import {Base64} from "../lib/openzeppelin-contracts/contracts/utils/Base64.sol";
import {MoodNft} from "../src/MoodNft.sol";
import {console} from "forge-std/console.sol";

contract DeployMoodNft is Script {
    function run() external returns (MoodNft) {
        string memory sadSvg = vm.readFile("./images/NFT2/sad.svg");
        string memory happySvg = vm.readFile("./images/NFT2/happy.svg");

        vm.startBroadcast();
        MoodNft moodNft = new MoodNft(svgToImageURI(sadSvg), svgToImageURI(happySvg));

        vm.stopBroadcast();
        return moodNft;
    }

    function svgToImageURI(string memory svg) public pure returns (string memory) {
        // We are creating this function so that everytime we get an image, we dont need
        // to write in terminal like: base64 --i example.svg and then create and special hash
        // We will write this fucntion so that it does the above steps for us.

        // so in this function, we will pass an SVG Code, and get the link in return
        string memory baseUrl = "data:image/svg+xml;base64,";
        string memory svgBase64Encoded = Base64.encode(bytes(string(abi.encodePacked(svg))));
        string memory link = string(abi.encodePacked(baseUrl, svgBase64Encoded));
        return link;
    }
}
