// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract zerachnft is ERC721, Ownable(msg.sender) {

    uint256 public tokenSupply = 0 ;
    uint256 public constant MAX_SUPPLY = 10;
    uint256 public constant PRICE = 1 ether;
    address deployer;

    constructor () ERC721 ("Zer4ch", "ZACH"){
        deployer = msg.sender;

    }

    function mint () external payable {
        require (tokenSupply < MAX_SUPPLY, "unable to mint!!");
        require (msg.value == PRICE , " wrong price");
        _mint(msg.sender, tokenSupply);
        tokenSupply++;
    }

    function veiwBalance () external view returns (uint256){
        return address(this).balance;
    }

    function withdraw() external {
        payable (deployer).transfer(address(this).balance);
    }

    function renounceOwnership() public pure override  {
        require (false, "cannot reanounce");
    }

    function transferOwnership(address) public pure override {
        require (false, "cannot transfer");
    }


}
