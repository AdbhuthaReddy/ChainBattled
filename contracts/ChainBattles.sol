//SPDX-License-Identifier: Unlicense

// Deployed address :  0xcCa7f7b8e085f32621157492826CB10E3F863e9c

pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

contract ChainBattles is ERC721URIStorage{
      using Strings for uint256;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    
    struct Details{
        string Warrior;
        uint256 Level;
        uint256 HP;
        uint256 Strength;
        uint256 Life;
    }
      
     mapping(uint256 => Details) public tokenIdDetails;


    constructor() ERC721 ("Chain Battles", "BTLS"){
    }


    function generateCharacter(uint256 tokenId) public view returns(string memory){

    bytes memory svg = abi.encodePacked(
    '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350">',
        '<style>.base { fill: white; font-family: serif; font-size: 14px; }</style>',
        '<rect width="100%" height="100%" fill="black" />',
        '<text x="50%" y="40%" class="base" dominant-baseline="middle" text-anchor="middle">',"Warrior: ",getWarrior(tokenId),'</text>',
        '<text x="50%" y="50%" class="base" dominant-baseline="middle" text-anchor="middle">', "Level: ",getLevel(tokenId),'</text>',
        '<text x="50%" y="60%" class="base" dominant-baseline="middle" text-anchor="middle">', "Hitpoints: ",getHP(tokenId),'</text>',
        '<text x="50%" y="70%" class="base" dominant-baseline="middle" text-anchor="middle">', "Strength: ",getStrength(tokenId),'</text>',
        '<text x="50%" y="80%" class="base" dominant-baseline="middle" text-anchor="middle">', "Life: ",getLife(tokenId),'</text>',
        '</svg>'
    );
    return string(
        abi.encodePacked(
            "data:image/svg+xml;base64,",
            Base64.encode(svg)
        )    
    );
    }

    function getWarrior(uint256 tokenId) public view returns (string memory) {
    string memory Warrior = tokenIdDetails[tokenId].Warrior;
    return Warrior;
    }
    function getLevel (uint256 tokenId) public view returns (string memory) {
    uint256 Level = tokenIdDetails[tokenId].Level;
    return Level.toString();
    }

    function getHP(uint256 tokenId) public view returns (string memory) {
    uint256 Hp = tokenIdDetails[tokenId].HP;
    return Hp.toString();
    }
    function getStrength(uint256 tokenId) public view returns (string memory) {
     uint256 Strength = tokenIdDetails[tokenId].Strength;
    return Strength.toString();
    }
    function getLife(uint256 tokenId) public view returns (string memory) {
     uint256 Life = tokenIdDetails[tokenId].Life;
    return Life.toString();
    }

    function mint() public {
    _tokenIds.increment();
    uint256 newItemId = _tokenIds.current();
    _safeMint(msg.sender, newItemId);
    random(100);
    tokenIdDetails[newItemId].Warrior = "Newbie";
    tokenIdDetails[newItemId].HP=100;
    tokenIdDetails[newItemId].Level=1;                 
    tokenIdDetails[newItemId].Strength=20;
    tokenIdDetails[newItemId].Life=1;
    _setTokenURI(newItemId, getTokenURI(newItemId)); 
}

function getTokenURI(uint256 tokenId) public view returns (string memory){
    bytes memory dataURI = abi.encodePacked(
        '{',
            '"name": "Chain Battles #', tokenId.toString(), '",',
            '"description": "Battles on chain",',
            '"image": "', generateCharacter(tokenId), '"',
        '}'
    );
    return string(
        abi.encodePacked(
            "data:application/json;base64,",
            Base64.encode(dataURI)
        )
    );
}

 function train(uint256 tokenId) public {
   require(_exists(tokenId));
   require(ownerOf(tokenId) == msg.sender, "You must own this NFT to train it!");

   tokenIdDetails[tokenId].Level +=1; 
   tokenIdDetails[tokenId].HP *=2;
    tokenIdDetails[tokenId].Strength +=10; 
   tokenIdDetails[tokenId].Warrior = (tokenIdDetails[tokenId].Strength>50)?"legendary":"Expert";
   tokenIdDetails[tokenId].Life = random(100);
   _setTokenURI(tokenId, getTokenURI(tokenId));
}

function random(uint number) public view returns (uint256) {
        uint256 Rnumber =( uint(keccak256(abi.encodePacked(block.timestamp,block.difficulty,  
        msg.sender))) % number);
        return Rnumber;
    }


}