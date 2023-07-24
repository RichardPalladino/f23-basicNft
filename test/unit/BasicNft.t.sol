// SPDX-License-Identifier: MIT

pragma solidity 0.8.18;

import {Test} from "forge-std/Test.sol";
import {DeployBasicNft} from "../../script/DeployBasicNft.s.sol";
import {BasicNft} from "../../src/BasicNft.sol";

contract TestBasicNft is Test {
    DeployBasicNft public deployer;
    BasicNft public basicNft;
    address public USER = makeAddr("user");
    string public constant PUG_URI = "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json";

    function setUp() public {
        deployer = new DeployBasicNft();
        basicNft = deployer.run();
    }

    function testNameIsCorrect() public view {
        string memory expectedName = "Doggie";
        string memory actualName = basicNft.name();
        assert(keccak256(abi.encodePacked(actualName)) == keccak256(abi.encodePacked(expectedName)));
    }

    function testCanMint() public {
        vm.prank(USER);
        basicNft.mintNft(PUG_URI);

        assertEq(basicNft.balanceOf(USER), 1);  
        assertEq(basicNft.tokenURI(0), PUG_URI);
        assert(keccak256(abi.encodePacked(basicNft.tokenURI(0))) == keccak256(abi.encodePacked(PUG_URI)));

    }

}