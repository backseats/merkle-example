// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {MerkleExample} from "../src/MerkleExample.sol";
import {Merkle} from "murky/Merkle.sol";
import "forge-std/console.sol";

contract MerkleExampleTest is Test {
    MerkleExample public merkleExample;

    function setUp() public {
        merkleExample = new MerkleExample();
    }

    function test_verifyProof() public {
        bytes32[] memory data = new bytes32[](6);
        data[0] = keccak256(abi.encodePacked(uint256(1)));
        data[1] = keccak256(abi.encodePacked(uint256(2)));
        data[2] = keccak256(abi.encodePacked(uint256(3)));
        data[3] = keccak256(abi.encodePacked(uint256(4)));
        data[4] = keccak256(abi.encodePacked(uint256(6)));
        data[5] = keccak256(abi.encodePacked(uint256(7)));

        // console.log("Leaf values:");
        // for (uint i = 0; i < data.length; i++) {
        //     console.logBytes32(data[i]);
        // }

        Merkle merkle = new Merkle();
        bytes32 _root = merkle.getRoot(data);

        bytes32 root = merkleExample.root();
        console.log("root");
        console.logBytes32(root);

        assertEq(root, _root);

        bytes32[] memory proof = merkleExample.getProof(2);
        assertTrue(merkleExample.verify(proof, 3));
    }
}
