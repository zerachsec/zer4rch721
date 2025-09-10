# zer4ch / zerach NFT Contracts

This repository contains two example ERC‑721 contracts implemented as a learning project (learned from RareSkills):

* `Zer4chERC721.sol` — a **fully manually-written** ERC‑721 implementation (no OpenZeppelin inheritance). This contract is intentionally educational: it shows the plumbing of ERC‑721 (minting, transfers, approvals, metadata) so you can learn how the pieces fit together.

* `ZerachNFT.sol` — a production-friendly ERC‑721 contract **inheriting from OpenZeppelin** `ERC721` and related helpers. Token name: `ZerachNFT`, Symbol: `ZACH`.

> Author / learning credit: built while studying RareSkills. Contract author: `zerach` (alias `zer4ch`).

---

## Repository layout (suggested file names)

```
contracts/
  Zer4chERC721.sol        # manually written ERC-721 (educational)
  ZerachNFT.sol           # OpenZeppelin-based ERC-721 (symbol ZACH)

scripts/
  deploy_zer4ch.js        # deployment script for Zer4chERC721
  deploy_zerach.js        # deployment script for ZerachNFT

test/
  Zer4chERC721.t.sol      # Foundry / Solidity tests or JS tests
  ZerachNFT.t.sol

README.md
LICENSE

foundry.toml
```

---

## `Zer4chERC721.sol` — overview

This contract is a ground-up implementation of the ERC‑721 interface for educational purposes. It demonstrates:

* `balanceOf`, `ownerOf`, `approve`, `getApproved`, `setApprovalForAll`, `isApprovedForAll`.
* `transferFrom`, `safeTransferFrom` (with ERC721Receiver checks).
* Minimal `tokenURI` support (on‑chain or base URI pattern).
* `_mint` and `_burn` internals with events: `Transfer`, `Approval`.
* Gas-saving patterns and notes on where OpenZeppelin improves safety.

**Important:** This contract is for learning. For production, prefer audited libraries (e.g., OpenZeppelin).

---

## `ZerachNFT.sol` — overview

This contract inherits from OpenZeppelin's `ERC721`, plus commonly used extensions (depending on your needs):

* `ERC721Enumerable` (optional) — if you need enumeration (warn: gas cost).
* `ERC721URIStorage` — for per-token metadata URIs.
* `Ownable` or `AccessControl` — to restrict minting to owner/minter role.

Token name: **ZerachNFT**
Token symbol: **ZACH**

A minimal example:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract ZerachNFT is ERC721URIStorage, Ownable {
    uint256 private _nextTokenId = 1;

    constructor() ERC721("ZerachNFT", "ZACH") {}

    function mint(address to, string memory uri) external onlyOwner returns (uint256) {
        uint256 id = _nextTokenId;
        _nextTokenId = id + 1;
        _safeMint(to, id);
        _setTokenURI(id, uri);
        return id;
    }
}
```

This pattern is simple, upgradeable to more complex minting logic (sale phases, merkle allowlists, royalties, etc.).

---

## How to use (Foundry)

These instructions assume you use Foundry (installed). If you prefer Hardhat or Truffle, adapt the scripts accordingly.

1. Install deps (example):

```bash
# init foundry if not already
forge init

# install OpenZeppelin contracts
forge install OpenZeppelin/openzeppelin-contracts
```

2. Place contract files under `contracts/` and configure `foundry.toml`.

3. Compile

```bash
forge build
```

4. Run tests

```bash
forge test
```

5. Deploy locally (example script using `cast` or a small JS/TS script):

```bash
# Start a local anvil node
anvil &

# deploy with forge script or with cast + abi
forge create --rpc-url http://127.0.0.1:8545 --private-key <KEY> src/ZerachNFT.sol:ZerachNFT
```

Or use `scripts/deploy_zerach.js` (ethers.js) and `node`.

---

## Example usage (ethers.js)

```js
// mint a token with ZerachNFT (owner only)
const contract = new ethers.Contract(ADDRESS, ABI, signer);
const tx = await contract.mint(userAddress, "ipfs://Qm.../metadata.json");
await tx.wait();
```

---

## Security notes & recommendations

* The manually written `Zer4chERC721.sol` is educational only. It intentionally implements core mechanics so you can study potential pitfalls (reentrancy, missing checks, incorrect approval logic). Do not deploy it to mainnet for valuable assets.

* Use OpenZeppelin's audited contracts in production (`ZerachNFT.sol` shows how).

* Consider adding:

  * Reentrancy guards on functions that transfer value.
  * Safe math (Solidity >=0.8 has built-in overflow checks).
  * Explicit access control (`Ownable` or `AccessControl`) for mint functions.
  * ERC‑2981 royalties if you need marketplace royalties.

* Gas vs functionality tradeoffs: `ERC721Enumerable` is convenient for UI but costly. Consider off‑chain indexing (The Graph) for large collections.

---

## Testing checklist (recommended tests)

* Basic ERC‑721 compliance tests:

  * `balanceOf`, `ownerOf`, `approve`, `transferFrom`, `safeTransferFrom`, `setApprovalForAll`.

* Edge cases:

  * Transfer to `address(0)` should revert.
  * Minting the same `tokenId` twice should revert.
  * `safeTransferFrom` to a contract without `onERC721Received` should revert.

* Access control tests:

  * Only owner can `mint` in `ZerachNFT`.

* Metadata tests:

  * `tokenURI` returns expected value after mint.

---

## Extending this project

Ideas to extend your learning:

* Implement batch minting and compare gas costs.
* Add a simple sale (public mint) with supply cap.
* Add signature-based allowlists (EIP‑712 / lazy minting).
* Add ERC‑2981 royalty support.
* Add payment splitting for revenue sharing.

---

## License

This example README and sample contracts can be licensed under MIT. See `LICENSE`.

---

## Acknowledgements

* Learned from RareSkills tutorials and exercises.
* OpenZeppelin contracts for secure building blocks.

---
