// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/utils/Strings.sol";

contract zer4ch721 {
    using Strings for uint256;
    event Transfer(
        address indexed _from,
        address indexed _to,
        uint256 indexed _tokenId
    );
    event ApprovalForAll(
        address indexed _owner,
        address indexed _operator,
        bool _approved
    );

    mapping(uint256 => address) private _owner;
    mapping(address => mapping(address => bool)) private _operators;
    mapping(address => uint256) private balances;

    string baseURL = "https://example.com/images/";

    function mint(uint256 _tokenId) external {
        require(_owner[_tokenId] == address(0), "already Minted");
        require(_tokenId < 100, "_tokenId too large");
        emit Transfer(address(0), msg.sender, _tokenId);
        _owner[_tokenId] = msg.sender;
        balances[msg.sender] += 1;
    }

    function ownerOf(uint256 _tokenId) external view returns (address) {
        require(_owner[_tokenId] != address(0), "no such token");
        return _owner[_tokenId];
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) external payable {
        require(_owner[_tokenId] == _from, "cannot transfer from");
        require(_owner[_tokenId] != address(0), "token does not exist");
        require(
            msg.sender == _from || _operators[_from][msg.sender],
            "required to be Owner"
        );
        emit Transfer(_from, _to, _tokenId);
        _operators[_from][msg.sender] = false;
        _owner[_tokenId] = _to;
        balances[_from] -= 1;
        balances[_to] += 1;
    }

    function tokenURI(uint256 _tokenId) external view returns (string memory) {
        require(_owner[_tokenId] != address(0), "does not exist");
        return string(abi.encodePacked(baseURL, _tokenId.toString(), ".jpg"));
    }

    function setApprovalForAll(address _operator, bool _approved) external {
        _operators[msg.sender][_operator] = _approved;
        emit ApprovalForAll(msg.sender, _operator, _approved);
    }

    function balanceOf(address _Balanceowner) external view returns (uint256) {
        require(_Balanceowner != address(0), "zero address");
        return balances[_Balanceowner];
    }
}
