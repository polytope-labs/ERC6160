pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import "../src/tokens/ERC6160Ext1155.sol";

contract ERC1155Test is Test {
    ERC6160Ext1155 token;
    address beef = 0x000000000000000000000000000000000000bEEF;
    address dead = 0x000000000000000000000000000000000000dEaD;

    // supported interfaces
    bytes4 constant _IERC6160Ext1155_ID_ = 0x9f77104c;
    bytes4 constant _IERC_ACL_CORE_ID_ = 0x6bb9cd16;
    bytes4 constant _IERC5679Ext1155_ID_ = 0xf4cedd5a;

    // roles
    bytes32 constant MINTER_ROLE = keccak256("MINTER ROLE");
    bytes32 constant BURNER_ROLE = keccak256("BURNER ROLE");

    uint256 TOKEN1_NFT = 0;
    uint256 TOKEN2_FT = 1;

    function setUp() public {
        token = new ERC6160Ext1155(address(this), "");
    }

    function testRoles() public view {
        assert(token.hasRole(MINTER_ROLE, address(this)));
        assert(token.hasRole(BURNER_ROLE, address(this)));
    }

    function testFailNotRoles() public view {
        // test not granted roles
        assert(token.hasRole(MINTER_ROLE, beef));
        assert(token.hasRole(BURNER_ROLE, beef));
    }

    function testGrantedRoles() public {
        // test granted roles
        token.grantRole(MINTER_ROLE, beef);
        token.grantRole(BURNER_ROLE, beef);
        assert(token.hasRole(MINTER_ROLE, beef));
        assert(token.hasRole(BURNER_ROLE, beef));
    }

    function testSupportInterfaces() public view {
        assert(token.supportsInterface(_IERC6160Ext1155_ID_));
        assert(token.supportsInterface(_IERC5679Ext1155_ID_));
        /*assert(token.supportsInterface(_IERC_ACL_CORE_ID_));*/
    }

    function testMintAndBurn() public {
        token.safeMint(beef, TOKEN1_NFT, 1, bytes(""));
        assertEq(token.balanceOf(beef, TOKEN1_NFT), 1);
    }

    function testFailMintAndBurn() public {
        // from an unprivledged account should fail
        vm.prank(dead);
        token.safeMint(beef, TOKEN1_NFT, 1, bytes(""));
    }

    function testMintAndBurnBatch() public {
        uint256[] memory tokenIds = new uint256[](2);
        tokenIds[0] = TOKEN1_NFT;
        tokenIds[1] = TOKEN2_FT;
        uint256[] memory amounts = new uint256[](2);
        amounts[0] = 1;
        amounts[1] = 1000;
        token.safeMintBatch(beef, tokenIds, amounts, bytes(""));
        assertEq(token.balanceOf(beef, TOKEN1_NFT), 1);
        assertEq(token.balanceOf(beef, TOKEN2_FT), 1000);
    }

    function testFailMintAndBurnBatch() public {
        uint256[] memory tokenIds = new uint256[](2);
        tokenIds[0] = TOKEN1_NFT;
        tokenIds[1] = TOKEN2_FT;
        uint256[] memory amounts = new uint256[](2);
        amounts[0] = 1;
        amounts[1] = 1000;
        // from an unprivledged account should fail
        vm.prank(dead);
        token.safeMintBatch(beef, tokenIds, amounts, bytes(""));
        assertEq(token.balanceOf(beef, TOKEN1_NFT), 1);
        assertEq(token.balanceOf(beef, TOKEN2_FT), 1000);
    }
}
