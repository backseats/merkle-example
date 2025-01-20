// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "murky/Merkle.sol";

contract MerkleExample {
    Merkle public merkle;
    bytes32 public root;

    constructor() {
        merkle = new Merkle();

        // Create leaves from inputs [1,2,3,4,6]
        bytes32[] memory data = new bytes32[](6);
        data[0] = keccak256(abi.encodePacked(uint256(1)));
        data[1] = keccak256(abi.encodePacked(uint256(2)));
        data[2] = keccak256(abi.encodePacked(uint256(3)));
        data[3] = keccak256(abi.encodePacked(uint256(4)));
        data[4] = keccak256(abi.encodePacked(uint256(6)));
        data[5] = keccak256(abi.encodePacked(uint256(7)));

        // Generate root using Murky
        root = merkle.getRoot(data);
    }

    function getProof(uint256 index) external view returns (bytes32[] memory) {
        bytes32[] memory data = new bytes32[](6);
        data[0] = keccak256(abi.encodePacked(uint256(1)));
        data[1] = keccak256(abi.encodePacked(uint256(2)));
        data[2] = keccak256(abi.encodePacked(uint256(3)));
        data[3] = keccak256(abi.encodePacked(uint256(4)));
        data[4] = keccak256(abi.encodePacked(uint256(6)));
        data[5] = keccak256(abi.encodePacked(uint256(7)));

        return merkle.getProof(data, index);
    }

    function verify(bytes32[] calldata proof, uint256 value) external view returns (bool) {
        bytes32 leaf = keccak256(abi.encodePacked(value));
        return merkle.verifyProof(root, proof, leaf);
    }
}
