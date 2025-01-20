const { MerkleTree } = require('merkletreejs')
const { ethers } = require('ethers')
const { keccak256 } = ethers

function solidityKeccak256(value) {
    // Convert to hex and pad to 32 bytes to match abi.encodePacked(uint256)
    const hex = value.toString(16).padStart(64, '0')
    return Buffer.from(keccak256('0x' + hex).slice(2), 'hex')
}

function hashPair(left, right) {
    // Sort the hashes (same as Murky)
    if (Buffer.compare(left, right) > 0) {
        [left, right] = [right, left]
    }
    // Concatenate and hash (same as Murky)
    return Buffer.from(keccak256('0x' + Buffer.concat([left, right]).toString('hex')).slice(2), 'hex')
}

async function main() {
    // Same inputs as Solidity
    const values = [1, 2, 3, 4, 6, 7]

    // Create leaves the same way as Solidity
    const leaves = values.map(v => solidityKeccak256(v))
    // console.log('Leaf values:')
    // leaves.forEach((leaf, i) => {
    //     console.log(`Leaf ${i}: 0x${leaf.toString('hex')}`)
    // })

    // Build tree level by level (same as Murky)
    let currentLevel = leaves
    while (currentLevel.length > 1) {
        const nextLevel = []
        for (let i = 0; i < currentLevel.length - 1; i += 2) {
            nextLevel.push(hashPair(currentLevel[i], currentLevel[i + 1]))
        }
        if (currentLevel.length % 2 === 1) {
            // If odd number of elements, hash the last one with zero bytes
            nextLevel.push(hashPair(currentLevel[currentLevel.length - 1], Buffer.alloc(32)))
        }
        currentLevel = nextLevel
    }

    const root = '0x' + currentLevel[0].toString('hex')
    console.log('Root:', root)

    // For proof generation, we'll still use merkletreejs
    const tree = new MerkleTree(leaves, keccak256, { sortPairs: true })
    const leaf = solidityKeccak256(3)
    const proof = tree.getProof(leaf).map(p => '0x' + p.data.toString('hex'))
    // console.log('Proof for value 3:', proof)
}

main().catch(console.error)
